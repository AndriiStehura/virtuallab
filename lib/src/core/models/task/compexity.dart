enum Complexity {
  easy,
  meduim,
  hard,
}

extension ComplexityInit on Complexity {
  static Complexity init(int value) {
    switch (value) {
      case 0:
        return Complexity.easy;
      case 1:
        return Complexity.meduim;
      case 2:
      default:
        return Complexity.hard;
    }
  }
}
