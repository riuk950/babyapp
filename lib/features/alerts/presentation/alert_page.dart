import 'package:flutter/material.dart';

import '../../../core/domain/age/age_band.dart';
import '../../../core/domain/alerts/alert_content.dart' as content;
import '../../../core/domain/alerts/alert_guide.dart';
import '../../../core/domain/alerts/alert_sign.dart';
import 'alert_controller.dart';
import 'l10n/app_localizations.dart';

/// Alerts screen root (RF-1..RF-5 · RNF-2, RNF-5 · CL-1/2/4/5/7/8/10/11 · §6).
///
/// An age-band selector plus, once a band is chosen, the alert signals of the
/// 5 areas all on the same screen, each with its urgency guide distinguished
/// by text and semantics (not only color). All business logic is delegated to
/// the [AlertController] (constitution §3C).
class AlertPage extends StatelessWidget {
  const AlertPage({super.key, required this.controller});

  final AlertController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBandSelector(context, l10n),
                const SizedBox(height: 16),
                _buildContent(context, l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBandSelector(BuildContext context, AppLocalizations l10n) {
    return InputDecorator(
      decoration: InputDecoration(labelText: l10n.selectPrompt),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AgeBand?>(
          value: controller.band,
          isExpanded: true,
          isDense: true,
          items: [
            DropdownMenuItem<AgeBand?>(
              value: null,
              child: Text(
                l10n.ageBandNone,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            for (final band in AgeBand.values)
              DropdownMenuItem<AgeBand?>(
                value: band,
                child: Text(
                  _bandOption(band),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: controller.selectBand,
        ),
      ),
    );
  }

  String _bandOption(AgeBand band) {
    final guide = content.contentFor(band)!;
    return '${guide.label} · ${guide.rangeMonths}';
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final guide = controller.guide;
    if (guide == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.selectPrompt,
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          _buildDisclaimer(context, controller.medicalDisclaimer),
        ],
      );
    }

    // Areas with no signals are omitted (never shown empty) (CL-10).
    final areas = guide.areas.where((a) => a.signals.isNotEmpty).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final area in areas) ...[
          Text(
            area.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final signal in area.signals)
            _buildSignal(context, signal),
          const SizedBox(height: 16),
        ],
        _buildDisclaimer(context, guide.medicalDisclaimer),
      ],
    );
  }

  Widget _buildSignal(BuildContext context, AlertSignal signal) {
    final urgency = signal.level == AlertLevel.urgency;
    final background = urgency ? Colors.red.shade50 : Colors.amber.shade50;
    final foreground = urgency ? Colors.red.shade900 : Colors.black87;
    final label = signal.level.label;
    final semanticsLabel = '$label: ${signal.signal}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        label: semanticsLabel,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ${signal.signal}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 6),
              Text(
                '$label — ${signal.action}',
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context, String disclaimer) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        disclaimer,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
