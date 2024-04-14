class SudokuPoints {
  int _points = 0;
  int _pointsForCorrectMove = 20;
  final int _minPointsForCorrectMove = 5;

  int get points => _points;

  void correctMove() {
    _points += _pointsForCorrectMove;
  }

  void wrongMove() {
    if (_pointsForCorrectMove > _minPointsForCorrectMove) {
      _pointsForCorrectMove -= 5;
    }
  }
}
