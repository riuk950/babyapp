import 'package:flutter/material.dart';

import '../../../core/domain/age/age_band.dart';
import '../../../core/domain/routine/routine_content.dart' as content;
import '../../../core/domain/routine/routine_moment.dart';
import '../../../core/domain/routine/routine_tip.dart';
import 'l10n/app_localizations.dart';
import 'routine_controller.dart';

/// Routine-tips screen root (RF-1..RF-6 · RNF-2, RNF-5 · CL-1..CL-10 · §6).
///
/// Two selectors (moment and age band) plus, once both are chosen, the tips
/// for that combination displayed all at once with equal visual weight — there
/// is no urgency distinction (RF-5). The medical disclaimer is always visible
/// (RF-6). All business logic is delegated to the [RoutineController]
/// (constitution §3C).
class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key, required this.controller});

  final RoutineController controller;

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
                _buildMomentSelector(context, l10n),
                const SizedBox(height: 12),
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

  Widget _buildMomentSelector(BuildContext context, AppLocalizations l10n) {
    return InputDecorator(
      decoration: InputDecoration(labelText: l10n.selectMomentPrompt),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RoutineMoment?>(
          value: controller.moment,
          isExpanded: true,
          isDense: true,
          items: [
            DropdownMenuItem<RoutineMoment?>(
              value: null,
              child: Text(
                l10n.momentNone,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            for (final moment in controller.moments)
              DropdownMenuItem<RoutineMoment?>(
                value: moment,
                child: Text(
                  moment.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: controller.selectMoment,
        ),
      ),
    );
  }

  Widget _buildBandSelector(BuildContext context, AppLocalizations l10n) {
    return InputDecorator(
      decoration: InputDecoration(labelText: l10n.selectBandPrompt),
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
                  content.bandOption(band),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: controller.selectBand,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final tips = controller.tips;
    if (tips == null || tips.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.selectMomentPrompt,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          _buildDisclaimer(context, controller.medicalDisclaimer),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tip in tips) _buildTip(context, l10n, tip),
        const SizedBox(height: 8),
        _buildDisclaimer(context, controller.medicalDisclaimer),
      ],
    );
  }

  Widget _buildTip(BuildContext context, AppLocalizations l10n, RoutineTip tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        label: '${tip.message}. ${tip.source}',
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ${tip.message}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 6),
              Text(
                '${l10n.sourcePrefix}: ${tip.source}',
                style: Theme.of(context).textTheme.bodySmall,
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
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        disclaimer,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
