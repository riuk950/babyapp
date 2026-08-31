import 'package:flutter/material.dart';

import '../../../core/domain/breastmilk/breastmilk_content.dart' as src;
import '../../../core/domain/breastmilk/breastmilk_guide.dart';
import '../../../core/domain/breastmilk/breastmilk_section.dart';
import 'breastmilk_controller.dart';
import 'l10n/app_localizations.dart';

/// Breast-milk screen root (RF-1..RF-5 · RNF-2, RNF-5 · CL-1/3/4/8/9, §6).
///
/// Shows the list of sections and delegates all business logic; selecting a
/// section opens a detail route (system back returns to the list in the
/// no-selection state, CL-8).
class BreastMilkPage extends StatelessWidget {
  const BreastMilkPage({super.key, required this.controller});

  final BreastMilkController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.selectPrompt,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final section in BreastMilkSection.values)
            ListTile(
              leading: const Icon(Icons.arrow_forward_ios, size: 18),
              title: Text(section.label),
              onTap: () => _openSection(context, l10n, section),
            ),
          const SizedBox(height: 8),
          _buildDisclaimer(
            context,
            controller.medicalDisclaimer,
            padding: const EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }

  void _openSection(BuildContext context, AppLocalizations l10n, BreastMilkSection section) {
    final content = src.contentFor(section);
    if (content == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _BreastMilkDetailPage(content: content),
      ),
    );
  }

  Widget _buildDisclaimer(
    BuildContext context,
    String disclaimer, {
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          disclaimer,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

/// Detail view for one section, pushed as its own route so the system back
/// returns to the list without remembering the selection (RF-1, CL-8).
class _BreastMilkDetailPage extends StatelessWidget {
  const _BreastMilkDetailPage({required this.content});

  final SectionContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(content.label)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.bestPracticesTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final practice in content.bestPractices)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $practice',
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            if (content.highlights.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._buildHighlights(context, l10n),
            ],
            if (content.storageTimeRows.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.storageTableTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildStorageTable(context, content.storageTimeRows),
            ],
            const SizedBox(height: 16),
            _buildDisclaimer(context, content.medicalDisclaimer),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHighlights(BuildContext context, AppLocalizations l10n) {
    return [
      for (final highlight in content.highlights)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Semantics(
            label: '${l10n.highlightPrefix}: $highlight',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${l10n.highlightPrefix}: $highlight',
                style: TextStyle(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
    ];
  }

  /// Storage-time table that reflows to a per-row list on narrow screens
  /// (≤320 dp) so no data is cut (CL-9, RNF-2).
  Widget _buildStorageTable(
    BuildContext context,
    List<StorageTimeRow> rows,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 320) {
          return Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1.4),
              2: FlexColumnWidth(1.8),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade100),
                children: [
                  _tableCell(context, 'Lugar', header: true),
                  _tableCell(context, 'Temperatura', header: true),
                  _tableCell(context, 'Tiempo', header: true),
                ],
              ),
              for (final row in rows)
                TableRow(
                  children: [
                    _tableCell(context, row.place),
                    _tableCell(context, row.temp),
                    _tableCell(context, row.duration),
                  ],
                ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(row.place,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text('${row.temp} · ${row.duration}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _tableCell(BuildContext context, String text, {bool header = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: header
            ? Theme.of(context).textTheme.titleSmall
            : Theme.of(context).textTheme.bodyMedium,
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
