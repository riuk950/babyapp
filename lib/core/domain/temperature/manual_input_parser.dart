import '../models.dart';

/// Parses and validates a manually entered temperature (RF-1, CL-1, CL-4).
///
/// Accepted format: optional sign, integer part, and up to one decimal digit,
/// using either a comma or a dot as the decimal separator. Surrounding spaces
/// are ignored. Valid range is -30..50 inclusive.
///
/// Returns a [ManualInputSuccess] with the value as whole tenths of a degree,
/// or a [ManualInputError] with a typed [ManualInputFailure].
ManualInputResult parseManualTemperature(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return ManualInputError(ManualInputFailure.empty);
  }

  final normalized = trimmed.replaceAll(',', '.');

  if (_hasMoreThanOneDecimal(normalized)) {
    return ManualInputError(ManualInputFailure.tooManyDecimals);
  }

  final numericPattern = RegExp(r'^[+-]?(\d+(\.\d{0,1})?|\.\d{1})$');
  if (!numericPattern.hasMatch(normalized)) {
    return ManualInputError(ManualInputFailure.notNumeric);
  }

  final tenths = _toTenths(normalized);

  if (tenths < -300 || tenths > 500) {
    return ManualInputError(ManualInputFailure.outOfRange);
  }

  return ManualInputSuccess(tenths);
}

bool _hasMoreThanOneDecimal(String value) {
  final firstDot = value.indexOf('.');
  if (firstDot == -1) return false;
  final secondDot = value.indexOf('.', firstDot + 1);
  if (secondDot != -1) return true;
  final fractional = value.substring(firstDot + 1);
  return fractional.length > 1;
}

int _toTenths(String value) {
  var sign = 1;
  var abs = value;
  if (abs.startsWith('-')) {
    sign = -1;
    abs = abs.substring(1);
  } else if (abs.startsWith('+')) {
    abs = abs.substring(1);
  }

  final parts = abs.split('.');
  final whole = parts[0].isEmpty ? '0' : parts[0];
  final fraction =
      parts.length > 1 && parts[1].isNotEmpty ? parts[1] : '0';

  return (int.parse(whole) * 10 + int.parse(fraction)) * sign;
}
