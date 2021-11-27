extension MapExt<K, V> on Map<K, V>? {
  bool get isBlank => this == null || this!.isEmpty;

  bool get isNotBlank => !isBlank;
}
