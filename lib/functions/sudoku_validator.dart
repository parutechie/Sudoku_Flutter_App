import 'dart:async';

class SudokuValidator {
  final List<List<int?>> sudokuGrid;

  SudokuValidator(this.sudokuGrid);

  Future<bool> validateCell(int row, int col, int? value) async {
    if (value == null || row < 0 || row >= 9 || col < 0 || col >= 9) {
      return false;
    }

    bool isValid = await Future.delayed(const Duration(milliseconds: 500), () {
      return isValidPlacement(row, col, value) &&
          isStrongPlacement(row, col, value);
    });

    return isValid;
  }

  bool isValidPlacement(int row, int col, int value) {
    for (int i = 0; i < 9; i++) {
      if (sudokuGrid[row][i] == value || sudokuGrid[i][col] == value) {
        return false;
      }
    }

    int subgridRow = (row ~/ 3) * 3;
    int subgridCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (sudokuGrid[subgridRow + i][subgridCol + j] == value) {
          return false;
        }
      }
    }

    return true;
  }

  bool isStrongPlacement(int row, int col, int value) {
    int subgridRow = (row ~/ 3) * 3;
    int subgridCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (sudokuGrid[subgridRow + i][subgridCol + j] == value) {
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> isValidSudoku() async {
    bool isValid = true;
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int? value = sudokuGrid[row][col];
        if (value != null) {
          bool cellValid = await validateCell(row, col, value);
          if (!cellValid) {
            isValid = false;
            break;
          }
        }
      }
      if (!isValid) {
        break;
      }
    }
    return isValid;
  }

  // Check if the Sudoku puzzle is solved
  bool isSudokuSolved() {
    // Check if any cell is empty
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (sudokuGrid[i][j] == null) {
          return false;
        }
      }
    }

    // Check if each row, column, and subgrid contains all numbers from 1 to 9
    return _areRowsValid() && _areColumnsValid() && _areSubgridsValid();
  }

  // Helper method to check if all rows are valid
  bool _areRowsValid() {
    for (int row = 0; row < 9; row++) {
      Set<int> rowSet = {};
      for (int col = 0; col < 9; col++) {
        int? value = sudokuGrid[row][col];
        if (value == null || rowSet.contains(value)) {
          return false;
        }
        rowSet.add(value);
      }
    }
    return true;
  }

  // Helper method to check if all columns are valid
  bool _areColumnsValid() {
    for (int col = 0; col < 9; col++) {
      Set<int> colSet = {};
      for (int row = 0; row < 9; row++) {
        int? value = sudokuGrid[row][col];
        if (value == null || colSet.contains(value)) {
          return false;
        }
        colSet.add(value);
      }
    }
    return true;
  }

  // Helper method to check if all subgrids are valid
  bool _areSubgridsValid() {
    for (int rowStart = 0; rowStart < 9; rowStart += 3) {
      for (int colStart = 0; colStart < 9; colStart += 3) {
        Set<int> subgridSet = {};
        for (int row = rowStart; row < rowStart + 3; row++) {
          for (int col = colStart; col < colStart + 3; col++) {
            int? value = sudokuGrid[row][col];
            if (value == null || subgridSet.contains(value)) {
              return false;
            }
            subgridSet.add(value);
          }
        }
      }
    }
    return true;
  }
}
