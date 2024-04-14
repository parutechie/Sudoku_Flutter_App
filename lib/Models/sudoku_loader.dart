import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sudoku/functions/sudoku_validator.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:sudoku/services/game_state_manager.dart';

class SudokuLoader {
  final List<List<int?>> _sudokuGrid;
  final List<List<bool>> _userFilled;
  final String _difficulty;

  SudokuLoader(this._sudokuGrid, this._userFilled, this._difficulty);

  Future<void> loadSudoku() async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('Sudoku_Tables');

      ListResult result = await ref.listAll();

      int randomIndex = Random().nextInt(result.items.length);
      Reference randomRef = result.items[randomIndex];

      String jsonString = await randomRef.getDownloadURL();
      http.Response response = await http.get(Uri.parse(jsonString));
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> sudokuList = data['sudoku'];

      _clearGrid();

      for (int i = 0; i < sudokuList.length; i++) {
        String key = sudokuList[i].keys.first;
        int? value = sudokuList[i][key];

        int row = 'ABCDEFGHI'.indexOf(key[0]);
        int col = int.parse(key[1]) - 1;

        _sudokuGrid[row][col] = value;
        _userFilled[row][col] = false;
      }

      int numbersToRemove = _getNumbersToRemove();

      _removeNumbers(numbersToRemove);

      _calculateRemainingNumbers();
      await GameStateManager.savedTableState(sudokuGrid: _sudokuGrid);
    } catch (e) {
      try {
        File file = File('assets/table.json');
        String jsonString = await file.readAsString();
        Map<String, dynamic> data = jsonDecode(jsonString);
        List<dynamic> sudokuList = data['sudoku'];

        _clearGrid();

        for (int i = 0; i < sudokuList.length; i++) {
          String key = sudokuList[i].keys.first;
          int? value = sudokuList[i][key];

          int row = 'ABCDEFGHI'.indexOf(key[0]);
          int col = int.parse(key[1]) - 1;

          _sudokuGrid[row][col] = value;
          _userFilled[row][col] = false;
        }

        int numbersToRemove = _getNumbersToRemove();

        _removeNumbers(numbersToRemove);

        _calculateRemainingNumbers();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void _clearGrid() {
    for (var row in _sudokuGrid) {
      row.fillRange(0, 9, null);
    }
    for (var row in _userFilled) {
      row.fillRange(0, 9, false);
    }
  }

  void _removeNumbers(int count) {
    while (count > 0) {
      int index = Random().nextInt(81);
      int row = index ~/ 9;
      int col = index % 9;

      if (_sudokuGrid[row][col] == null) continue;

      int? removedValue = _sudokuGrid[row][col];

      _sudokuGrid[row][col] = null;
      _userFilled[row][col] = true;

      if (!_hasUniqueSolution()) {
        _sudokuGrid[row][col] = removedValue;
        _userFilled[row][col] = false;
      } else {
        count--;
      }
    }
  }

  bool _hasUniqueSolution() {
    List<List<int?>> sudokuCopy =
        List.generate(9, (_) => List<int?>.filled(9, null));
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        sudokuCopy[i][j] = _sudokuGrid[i][j];
      }
    }
    return _solveSudoku(sudokuCopy, 0, 0);
  }

  bool _solveSudoku(List<List<int?>> grid, int row, int col) {
    if (row == 9) {
      row = 0;
      if (++col == 9) {
        return true;
      }
    }
    if (grid[row][col] != null) {
      return _solveSudoku(grid, row + 1, col);
    }
    for (int num = 1; num <= 9; num++) {
      if (SudokuValidator(grid).isValidPlacement(row, col, num)) {
        grid[row][col] = num;
        if (_solveSudoku(grid, row + 1, col)) {
          return true;
        }
        grid[row][col] = null;
      }
    }
    return false;
  }

  int _getNumbersToRemove() {
    switch (_difficulty) {
      case 'Easy':
        return 15;
      case 'Medium':
        return 25;
      case 'Hard':
        return 40;
      case 'Expert':
        return 50;
      case 'Master':
        return 60;
      default:
        return 20;
    }
  }

  void _calculateRemainingNumbers() {
    List<int> remainingNumbers = List<int>.filled(9, 9);
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (_sudokuGrid[row][col] != null) {
          remainingNumbers[_sudokuGrid[row][col]! - 1]--;
        }
      }
    }
  }
}
