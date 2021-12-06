enum Complexity {
  easy,
  meduim,
  hard,
}

extension ComplexityString on Complexity {
  String get string {
    switch (this) {
      case Complexity.easy:
        return 'Easy';
      case Complexity.meduim:
        return 'Medium';
      case Complexity.hard:
        return 'Hard';
    }
  }
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
