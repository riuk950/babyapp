import 'package:flutter/material.dart';

import '../../../core/domain/milestones/last_hit_resolver.dart';
import '../../../core/domain/milestones/milestone_guide.dart';
import '../../../core/domain/milestones/milestone_month.dart';
import 'l10n/app_localizations.dart';
import 'milestone_controller.dart';

/// Milestones screen root (RF-1..RF-5 · RNF-2, RNF-5 · CL-1/4/5/7/12 · §6).
///
/// Shows a searchable scrollable list of the 60 months; selecting a month
/// opens a detail route (system back returns to the no-month state, keeping
/// the app stateless).
class MilestonePage extends StatelessWidget {
  const MilestonePage({super.key, required this.controller});

  final MilestoneController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(l10n.selectPrompt),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: controller.setQuery,
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) => _buildBody(context, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (controller.hasNoSearchResults) {
      return ListView(
        children: [
          const SizedBox(height: 24),
          Center(child: Text(l10n.searchNoResults)),
          _disclaimer(context, controller.medicalDisclaimer),
        ],
      );
    }

    final months = controller.filteredMonths;
    return ListView(
      children: [
        for (final month in months)
          ListTile(
            title: Text('Mes ${month.number}'),
            subtitle: Text(month.ageLabel),
            onTap: () => _openMonth(context, month),
          ),
        _disclaimer(context, controller.medicalDisclaimer),
      ],
    );
  }

  void _openMonth(BuildContext context, MilestoneMonth month) {
    final resolved = resolveMonth(month);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _MonthDetailPage(resolved: resolved),
      ),
    );
  }

  Widget _disclaimer(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

/// Detail view for a resolved month, pushed as its own route so the system
/// back returns to the list without remembering the selection.
class _MonthDetailPage extends StatelessWidget {
  const _MonthDetailPage({required this.resolved});

  final ResolvedMonth resolved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes ${resolved.month.number}: ${resolved.label}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final area in resolved.areas) ...[
              Text(
                area.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              for (final item in area.items)
                _milestoneRow(context, l10n, area, item),
              if (area.alarmSigns.isNotEmpty) ...[
                const SizedBox(height: 8),
                _alarmBlock(context, l10n, area.alarmSigns),
              ],
              const SizedBox(height: 16),
            ],
            _disclaimer(context, resolved.medicalDisclaimer),
          ],
        ),
      ),
    );
  }

  Widget _milestoneRow(BuildContext context, AppLocalizations l10n,
      ResolvedArea area, MilestoneItem item) {
    if (!area.isLastHitReference) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text('• ${item.text}',
            style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    final labeled = '${l10n.previousHitLabel}: ${item.text}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Semantics(
        label: labeled,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            labeled,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.amber.shade900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _alarmBlock(
      BuildContext context, AppLocalizations l10n, List<String> alarms) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.alarmSignsTitle,
            style: TextStyle(
              color: Colors.red.shade900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          for (final alarm in alarms)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('• $alarm',
                  style: TextStyle(color: Colors.red.shade900)),
            ),
        ],
      ),
    );
  }

  Widget _disclaimer(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
