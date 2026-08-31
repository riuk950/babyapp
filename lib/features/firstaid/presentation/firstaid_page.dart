import 'package:flutter/material.dart';

import '../../../core/domain/age/age_band.dart';
import '../../../core/domain/firstaid/emergency_type.dart';
import '../../../core/domain/firstaid/firstaid_content.dart' as content;
import '../../../core/domain/firstaid/firstaid_step.dart';
import '../../../core/domain/firstaid/severity_level.dart';
import 'firstaid_controller.dart';
import 'l10n/app_localizations.dart';

/// First-aid screen root (RF-1..RF-6 · RNF-2, RNF-5 · CL-1..CL-11 · §6).
///
/// Two selectors (emergency and age band) plus, once both are chosen, the
/// numbered "what to do" steps, the separate "what NOT to do" section and a
/// severity indicator for that combination — all shown at once without
/// expandable content (HU-5). The severity is distinguished by its text label
/// and semantics, not only by color (RF-5, RNF-5). The medical disclaimer is
/// always visible (RF-6). All business logic is delegated to the
/// [FirstAidController] (constitution §3C).
class FirstAidPage extends StatelessWidget {
  const FirstAidPage({super.key, required this.controller});

  final FirstAidController controller;

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
                _buildEmergencySelector(context, l10n),
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

  Widget _buildEmergencySelector(BuildContext context, AppLocalizations l10n) {
    return InputDecorator(
      decoration: InputDecoration(labelText: l10n.selectEmergencyPrompt),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EmergencyType?>(
          value: controller.emergency,
          isExpanded: true,
          isDense: true,
          items: [
            DropdownMenuItem<EmergencyType?>(
              value: null,
              child: Text(
                l10n.emergencyNone,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            for (final emergency in controller.emergencies)
              DropdownMenuItem<EmergencyType?>(
                value: emergency,
                child: Text(
                  emergency.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: controller.selectEmergency,
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
    final guide = controller.guide;
    if (guide == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.selectEmergencyPrompt,
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
        _buildSeverity(context, guide.severity),
        const SizedBox(height: 16),
        Text(
          l10n.whatToDo,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final step in guide.steps) _buildStep(context, step, false),
        const SizedBox(height: 16),
        Text(
          l10n.whatNotToDo,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final step in guide.doNot) _buildStep(context, step, true),
        const SizedBox(height: 16),
        _buildDisclaimer(context, controller.medicalDisclaimer),
      ],
    );
  }

  Widget _buildSeverity(BuildContext context, SeverityLevel severity) {
    final isUrgency = severity == SeverityLevel.urgency;
    final background =
        isUrgency ? Colors.red.shade50 : Colors.teal.shade50;
    final foreground =
        isUrgency ? Colors.red.shade900 : Colors.teal.shade900;
    return Semantics(
      label: '${severity.label}: ${severity.actionGuide}',
      container: true,
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
              '${severity.label}:',
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              severity.actionGuide,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, FirstAidStep step, bool isDoNot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '${step.order}. ${step.text}',
        style: Theme.of(context).textTheme.bodyLarge,
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
