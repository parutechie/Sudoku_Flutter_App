import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameStateManager {
  static Future<void> savedTableState(
      {required List<List<int?>> sudokuGrid}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sudokuGrid', json.encode(sudokuGrid));
    // ignore: avoid_print
    print('Game table saved');
  }

  static Future<void> saveUserFilled({
    required List<List<bool>> userFilled,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userFilled', json.encode(userFilled));
    debugPrint('User filled cells saved');
  }

  static Future<void> saveUserFilledNumbers({
    required List<List<int?>> userFilledNumbers,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userFilledNumbers', json.encode(userFilledNumbers));
    // ignore: avoid_print
    print('User filled numbers saved');
  }

  static Future<void> saveUserPencilMarks({
    required List<List<List<int?>>> userPencilMarks,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userPencilMarks', json.encode(userPencilMarks));
    // ignore: avoid_print
    print('User pencil marks saved');
  }

  static Future<void> saveGameState({
    required String difficulty,
    required int remainingHints,
    required int mistakeCount,
    required int secondsElapsed,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('difficulty', json.encode(difficulty));
    prefs.setInt('remainingHints', remainingHints);
    prefs.setInt('mistakeCount', mistakeCount);
    prefs.setInt('secondsElapsed', secondsElapsed);
    // ignore: avoid_print
    print('Game state is saved');
  }

  static Future<void> saveGameSound(bool isGameSoundEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isGameSoundEnabled', isGameSoundEnabled);
    debugPrint('Game sound state saved');
  }

  static Future<void> saveDarkModeState(bool isDarkModeEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkModeEnabled', isDarkModeEnabled);
    debugPrint('Game dark state saved');
  }

  ///delete

  static Future<void> deleteGameState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('difficulty');
    prefs.remove('remainingHints');
    prefs.remove('mistakeCount');
    prefs.remove('secondsElapsed');
    prefs.remove('sudokuGrid');
    prefs.remove('userFilledNumbers');
    prefs.remove('userPencilMarks');
    debugPrint('Game state is deleted');
  }

////loader
  static Future<bool> loadGameSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGameSoundEnabled') ?? true;
  }

  static Future<bool> loadDarkModeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkModeEnabled') ?? false;
  }

  static Future<List<List<bool>>> loadUserFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('userFilled');
    if (jsonString != null) {
      return (json.decode(jsonString) as List<dynamic>).map<List<bool>>((row) {
        return List<bool>.from(row as List<dynamic>);
      }).toList();
    } else {
      throw Exception('No user filled cells saved');
    }
  }

  static Future<List<List<int?>>> loadUserFilledNumbers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('userFilledNumbers');
    if (jsonString != null) {
      return (json.decode(jsonString) as List<dynamic>).map<List<int?>>((row) {
        return List<int?>.from(row as List<dynamic>);
      }).toList();
    } else {
      throw Exception('No user filled numbers saved');
    }
  }

  static Future<Map<String, dynamic>> loadGameState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'difficulty': json.decode(prefs.getString('difficulty')!) as String,
      'remainingHints': prefs.getInt('remainingHints')!,
      'mistakeCount': prefs.getInt('mistakeCount')!,
      'secondsElapsed': prefs.getInt('secondsElapsed')!,
    };
  }

  static Future<List<List<List<int?>>>> loadUserPencilMarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('userPencilMarks');
    if (jsonString != null) {
      return (json.decode(jsonString) as List<dynamic>)
          .map<List<List<int?>>>((grid) {
        return (grid as List<dynamic>).map<List<int?>>((row) {
          return List<int?>.from(row as List<dynamic>);
        }).toList();
      }).toList();
    } else {
      throw Exception('No user pencil marks saved');
    }
  }

  static Future<List<List<int?>>> loadTableState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('sudokuGrid');
    if (jsonString != null) {
      return json.decode(jsonString).map<List<int?>>((row) {
        return List<int?>.from(row);
      }).toList();
    } else {
      throw Exception('No Sudoku table saved');
    }
  }
}
