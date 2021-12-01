double? tryParseDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value as double;
  return double.tryParse(value);
}
