import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sudoku/functions/sudoku_validator.dart';

typedef HintCallback = void Function(int row, int col, int number);

class SudokuFunctions {
  static void undo(
      List<List<int?>> sudokuGrid,
      List<List<bool>> userFilled,
      List<List<int?>> userFilledNumbers,
      int? selectedRow,
      int? selectedCol,
      int? prevValue) {
    if (selectedRow != null && selectedCol != null) {
      if (userFilled[selectedRow][selectedCol]) {
        sudokuGrid[selectedRow][selectedCol] = prevValue;
        userFilled[selectedRow][selectedCol] = false;
        userFilledNumbers[selectedRow][selectedCol] = prevValue;
      }
    }
  }

  static void eraser(List<List<int?>> sudokuGrid, List<List<bool>> userFilled,
      int? selectedRow, int? selectedCol) {
    if (selectedRow != null && selectedCol != null) {
      if (userFilled[selectedRow][selectedCol]) {
        sudokuGrid[selectedRow][selectedCol] = null;
      }
    }
  }

  static void hint(
      List<List<int?>> sudokuGrid,
      List<List<bool>> userFilled,
      List<List<int?>> userFilledNumbers,
      BuildContext context,
      Function(int, int, int) onHintApplied) {
    int row = Random().nextInt(9);
    int col = Random().nextInt(9);

    while (sudokuGrid[row][col] != null) {
      row = Random().nextInt(9);
      col = Random().nextInt(9);
    }

    int number = Random().nextInt(9) + 1;
    if (SudokuValidator(sudokuGrid).isValidPlacement(row, col, number)) {
      sudokuGrid[row][col] = number;
      userFilled[row][col] = false; // Mark as not user filled
      userFilledNumbers[row][col] = number; // Update userFilledNumbers
      onHintApplied(row, col, number);
    } else {
      hint(sudokuGrid, userFilled, userFilledNumbers, context, onHintApplied);
    }
  }
}
