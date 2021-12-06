extension BlankCheck on String? {
  bool get isNotBlank => this != null && this!.isNotEmpty;

  bool get isBlank => !isNotBlank;
}
