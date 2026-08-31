import 'package:flutter/material.dart';

import '../../../core/domain/contracts/weather_repository.dart';
import '../../../core/domain/models.dart';
import '../../../core/data/geo/geolocator_service.dart';
import '../../../core/data/weather/open_meteo.dart';
import '../../../core/data/weather/weather_repository_impl.dart';
import 'clothing_controller.dart';
import 'l10n/app_localizations.dart';

/// Clothing screen (RF-1..RF-8 · RNF-2, RNF-5, §6).
///
/// Renders the UI and captures user events only; all business logic is
/// delegated to the [ClothingController] (constitution §3C). A [repository]
/// may be injected for testing; otherwise the real weather source is used.
class ClothingPage extends StatefulWidget {
  const ClothingPage({super.key, this.repository});

  final WeatherRepository? repository;

  @override
  State<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  late final ClothingController _controller;
  final _manualController = TextEditingController();
  AppLifecycleListener? _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _controller = ClothingController(
      weatherRepository: widget.repository ??
          WeatherRepositoryImpl(
            geoRepository: const GeolocatorService(),
            api: OpenMeteoApi(),
          ),
    );
    _lifecycleListener = AppLifecycleListener(
      onResume: _controller.onResume,
    );
    _controller.fetchGeo();
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    _manualController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onManualChanged(String value) {
    _controller.setManualTemperature(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildManualField(l10n),
                const SizedBox(height: 16),
                _buildAgeBandSelector(l10n),
                const SizedBox(height: 16),
                if (_controller.isGeoLoading)
                  _buildLoading(l10n)
                else
                  _buildNotice(l10n),
                const SizedBox(height: 16),
                _buildRecommendation(l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildManualField(AppLocalizations l10n) {
    final error = _controller.manualError;
    return TextField(
      controller: _manualController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l10n.manualTempLabel,
        hintText: l10n.manualTempHint,
        errorText: error == null ? null : _errorMessage(l10n, error),
      ),
      onChanged: _onManualChanged,
    );
  }

  Widget _buildAgeBandSelector(AppLocalizations l10n) {
    return DropdownButtonFormField<AgeBand?>(
      key: ValueKey(_controller.ageBand),
      initialValue: _controller.ageBand,
      decoration: InputDecoration(labelText: l10n.ageBandLabel),
      items: [
        DropdownMenuItem<AgeBand?>(
          value: null,
          child: Text(l10n.ageBandNone),
        ),
        for (final band in AgeBand.values)
          DropdownMenuItem<AgeBand?>(
            value: band,
            child: Text(_ageBandLabel(l10n, band)),
          ),
      ],
      onChanged: (value) => _controller.setAgeBand(value),
    );
  }

  Widget _buildLoading(AppLocalizations l10n) {
    return Row(
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(l10n.loadingWeather)),
      ],
    );
  }

  Widget _buildNotice(AppLocalizations l10n) {
    final notice = _controller.notice;
    if (notice == null) return const SizedBox.shrink();
    final message = switch (notice) {
      NoticeType.geoUnavailable => l10n.noticeGeoUnavailable,
      NoticeType.manualIgnored => l10n.noticeManualIgnored,
    };
    return Text(message, style: Theme.of(context).textTheme.bodyMedium);
  }

  Widget _buildRecommendation(AppLocalizations l10n) {
    final recommendation = _controller.recommendation;
    if (recommendation == null) {
      return Text(l10n.errorTemperatureRequired);
    }

    final extreme = _controller.extreme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (extreme != ExtremeLevel.none)
          _buildExtremeNotice(l10n, extreme),
        const SizedBox(height: 12),
        Text(
          l10n.recommendationTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          recommendation,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildExtremeNotice(AppLocalizations l10n, ExtremeLevel extreme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: extreme == ExtremeLevel.cold
            ? Colors.blue.shade100
            : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        extreme == ExtremeLevel.cold
            ? l10n.extremeCold
            : l10n.extremeHeat,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _errorMessage(AppLocalizations l10n, ManualInputFailure failure) {
    return switch (failure) {
      ManualInputFailure.outOfRange => l10n.errorOutOfRange,
      ManualInputFailure.empty ||
      ManualInputFailure.notNumeric ||
      ManualInputFailure.tooManyDecimals =>
        l10n.errorTemperatureRequired,
    };
  }

  String _ageBandLabel(AppLocalizations l10n, AgeBand band) {
    return switch (band) {
      AgeBand.newborn0to3 => l10n.ageBandNewborn,
      AgeBand.infant3to12 => l10n.ageBandInfant,
      AgeBand.toddler12to36 => l10n.ageBandToddler,
      AgeBand.child36to60 => l10n.ageBandChild,
    };
  }
}
