import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/core/domain/alerts/alert_guide.dart';
import 'package:babyapp/core/domain/alerts/alert_sign.dart';

void main() {
  group('AlertLevel — closed urgency enum (RF-3, CL-8)', () {
    test('has exactly two mutually exclusive values', () {
      expect(AlertLevel.values, hasLength(2));
      expect(AlertLevel.values.toSet(), hasLength(2));
    });

    test('each value carries a Spanish label and is distinguishable by text',
        () {
      expect(AlertLevel.urgency.label, isNotEmpty);
      expect(AlertLevel.scheduled.label, isNotEmpty);
      expect(AlertLevel.urgency.label, isNot(AlertLevel.scheduled.label));
    });

    test('a signal belongs to exactly one level (RF-3, CL-8)', () {
      const signal = AlertSignal(
        signal: 'Dificultad para respirar',
        level: AlertLevel.urgency,
        action: 'Acude a urgencias de inmediato.',
      );
      // The model stores a single AlertLevel per signal; there is no way to
      // hold more than one (RF-3). The action text is data, not derived by
      // heuristics (CL-11).
      expect(signal.level, isA<AlertLevel>());
      expect(signal.action, isNotEmpty);
    });
  });

  group('AlertSignal model (RF-2, RF-3, RF-5)', () {
    test('deterministic: same values yield equal objects with same fields',
        () {
      const a = AlertSignal(
        signal: 'No sostiene la cabeza firme',
        level: AlertLevel.scheduled,
        action: 'Consulta pronto con tu pediatra.',
      );
      const b = AlertSignal(
        signal: 'No sostiene la cabeza firme',
        level: AlertLevel.scheduled,
        action: 'Consulta pronto con tu pediatra.',
      );
      expect(a.signal, b.signal);
      expect(a.level, b.level);
      expect(a.action, b.action);
    });
  });

  group('AreaAlerts model (RF-2, RF-3, CL-10)', () {
    test('holds an area label and its signals (possibly empty)', () {
      const area = AreaAlerts(
        area: AlertArea.grossMotor,
        label: 'Motricidad gruesa',
        signals: [],
      );
      expect(area.area, AlertArea.grossMotor);
      expect(area.label, 'Motricidad gruesa');
      expect(area.signals, isEmpty);
    });

    test('exposes exactly the 5 development areas, unique (RF-2, CL-8)', () {
      expect(AlertArea.values, hasLength(5));
      expect(AlertArea.values.toSet(), hasLength(5));
    });
  });

  group('AlertGuide model (RF-2, RF-3, RF-5)', () {
    test('deterministic: same band always yields the same guide fields', () {
      const guide = AlertGuide(
        band: AgeBand.newborn0to3,
        label: '0–3 meses',
        rangeMonths: '[0,3)',
        areas: [],
        medicalDisclaimer: 'Aviso médico',
      );
      expect(guide.band, AgeBand.newborn0to3);
      expect(guide.label, '0–3 meses');
      expect(guide.rangeMonths, '[0,3)');
      expect(guide.medicalDisclaimer, 'Aviso médico');
    });

    test('areas with no signals are omitted from the render list (CL-10)', () {
      const guide = AlertGuide(
        band: AgeBand.newborn0to3,
        label: '0–3 meses',
        rangeMonths: '[0,3)',
        areas: [
          AreaAlerts(area: AlertArea.grossMotor, label: 'Motricidad gruesa',
              signals: []),
          AreaAlerts(
              area: AlertArea.language,
              label: 'Lenguaje',
              signals: [
                AlertSignal(
                    signal: 'No balbucea',
                    level: AlertLevel.scheduled,
                    action: 'Consulta con tu pediatra.')
              ]),
        ],
        medicalDisclaimer: 'Aviso médico',
      );
      final visible = guide.areas.where((a) => a.signals.isNotEmpty).toList();
      expect(visible, hasLength(1));
      expect(visible.single.area, AlertArea.language);
    });
  });
}
