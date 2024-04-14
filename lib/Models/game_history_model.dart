class GameHistoryModel {
  final int time;
  final String difficulty;
  final int points;
  final int mistakes;
  final String imageUrl;

  GameHistoryModel({
    required this.time,
    required this.difficulty,
    required this.points,
    required this.mistakes,
    required this.imageUrl,
  });
}
