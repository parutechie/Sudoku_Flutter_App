import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:sudoku/services/game_state_manager.dart';

class SudokuQuestLoader {
  final List<List<int?>> _sudokuGrid;
  final List<List<bool>> _userFilled;
  final DateTime selectedDate;

  SudokuQuestLoader(this._sudokuGrid, this._userFilled, this.selectedDate);

  Future<void> loadSudoku(DateTime selectedDate) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('Daily_quest_tables');

      String storagePath =
          '${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}.json';

      Reference sudokuRef = ref.child(storagePath);

      String jsonString = await sudokuRef.getDownloadURL();
      http.Response response = await http.get(Uri.parse(jsonString));
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> sudokuList = data['sudoku'];

      _clearGrid();

      for (int i = 0; i < sudokuList.length; i++) {
        String key = sudokuList[i].keys.first;
        int? value = sudokuList[i][key];

        int row = 'ABCDEFGHI'.indexOf(key[0]);
        int col = int.parse(key[1]) - 1;

        // Check if value is not 0, then add to grid
        if (value != 0) {
          _sudokuGrid[row][col] = value;
          _userFilled[row][col] = false;
        }
      }
      _calculateRemainingNumbers();
      await GameStateManager.savedTableState(sudokuGrid: _sudokuGrid);
    } catch (e) {
      // Handle errors
      debugPrint('Error loading Sudoku table: $e');
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
