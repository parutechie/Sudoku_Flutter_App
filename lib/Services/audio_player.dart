import 'package:audioplayers/audioplayers.dart';

class SudokuAudioPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playButtonSound() async {
    await _audioPlayer.play(AssetSource('audio/button_click.mp3'));
  }

  Future<void> playCorrectMoveSound() async {
    await _audioPlayer.play(AssetSource('audio/correct_move.mp3'));
  }

  Future<void> playWrongMoveSound() async {
    await _audioPlayer.play(AssetSource('audio/wrong_move.mp3'));
  }

  Future<void> playEraserSound() async {
    await _audioPlayer.play(AssetSource('audio/eraser.mp3'));
  }

  Future<void> playPencilSound() async {
    await _audioPlayer.play(AssetSource('audio/pencil.mp3'));
  }

  Future<void> playVictorySound() async {
    await _audioPlayer.play(AssetSource('audio/game_victory.mp3'));
  }
}
