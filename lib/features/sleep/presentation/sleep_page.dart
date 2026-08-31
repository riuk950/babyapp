import 'package:flutter/material.dart';

import '../../../core/domain/age/age_band.dart';
import '../../../core/domain/sleep/sleep_content.dart' as content;
import '../../../core/domain/sleep/sleep_guide.dart';
import 'l10n/app_localizations.dart';
import 'sleep_controller.dart';

/// Sleep screen (RF-1..RF-5 · RNF-2, RNF-5 · CL-4/5/7, §6).
///
/// Renders the UI and captures user events only; all business logic is
/// delegated to the [SleepController] (constitution §3C).
class SleepPage extends StatelessWidget {
  const SleepPage({super.key, required this.controller});

  final SleepController controller;

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
    // A DropdownButton with isExpanded:true inside an InputDecorator keeps the
    // selector within the available width on narrow screens (RNF-2, CL-5),
    // avoiding the overflow of a bare DropdownButtonFormField.
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
    final guide = _guideFor(band);
    return '${guide.label} · ${guide.rangeMonths}';
  }

  SleepGuide _guideFor(AgeBand band) {
    // The selector only offers AgeBand.values, so a guide always exists.
    return content.guideFor(band)!;
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final guide = controller.guide;
    if (guide == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.selectPrompt, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          _buildDisclaimer(context, controller.medicalDisclaimer),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSection(
          context,
          l10n.totalHoursTitle,
          guide.totalHoursPerDay,
        ),
        const SizedBox(height: 12),
        _buildSection(context, l10n.napsTitle, guide.naps),
        const SizedBox(height: 12),
        _buildSection(context, l10n.bedtimeTitle, guide.bedtimeSchedule),
        const SizedBox(height: 12),
        _buildSignsSection(
          context,
          l10n.insufficientSignsTitle,
          guide.insufficientSleepSigns,
          Colors.orange.shade50,
          Colors.black87,
        ),
        const SizedBox(height: 16),
        _buildSignsSection(
          context,
          l10n.alarmSignsTitle,
          guide.alarmSigns,
          Colors.red.shade50,
          Colors.red.shade900,
        ),
        const SizedBox(height: 16),
        _buildDisclaimer(context, guide.medicalDisclaimer),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildSignsSection(
    BuildContext context,
    String title,
    List<String> signs,
    Color background,
    Color foreground,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final sign in signs)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $sign',
                style: TextStyle(color: foreground),
              ),
            ),
        ],
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
