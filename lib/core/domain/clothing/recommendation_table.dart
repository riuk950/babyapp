import '../models.dart';

/// Recommendation table (RF-7): contiguous integer ranges covering -30..50
/// without gaps or overlaps (CL-2), so each value maps to a single range.
const List<({int min, int max, String text})> _ranges = [
  (
    min: -30,
    max: -6,
    text: 'Body térmico + body manga larga + jersey y chaqueta de abrigo; gorro',
  ),
  (
    min: -5,
    max: 5,
    text: 'Body manga larga + jersey + chaqueta de abrigo; gorro',
  ),
  (
    min: 6,
    max: 12,
    text: 'Body manga larga + chaqueta o sudadera ligera',
  ),
  (
    min: 13,
    max: 17,
    text: 'Body manga larga; jersey fino opcional',
  ),
  (
    min: 18,
    max: 24,
    text: 'Body manga corta de algodón + pantalón; chaleco fino opcional',
  ),
  (
    min: 25,
    max: 29,
    text: 'Body manga corta de algodón; evitar abrigar',
  ),
  (
    min: 30,
    max: 50,
    text: 'Solo body/babador de algodón transpirable',
  ),
];

/// Index (0-based) of the range containing [celsius], or `-1` if none.
int temperatureRangeIndexFor(int celsius) {
  for (var i = 0; i < _ranges.length; i++) {
    if (celsius >= _ranges[i].min && celsius <= _ranges[i].max) return i;
  }
  return -1;
}

/// Returns the clothing recommendation text for the given effective
/// temperature and age band, including the newborn +1 layer adjustment in the
/// cold ranges (<= 12 C) (RF-7).
String recommendationFor(int celsius, AgeBand band) {
  final index = temperatureRangeIndexFor(celsius);
  if (index == -1) return '';
  var text = _ranges[index].text;

  if (band == AgeBand.newborn0to3 && celsius <= 12) {
    text = '$text + 1 capa';
  }

  return text;
}
