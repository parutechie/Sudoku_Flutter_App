import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';
import 'package:sudoku/Pages/settings_page.dart';
import 'package:sudoku/Pages/win_page.dart';
import 'package:sudoku/Services/audio_player.dart';
import 'package:sudoku/Widgets/Loader/loading_animation.dart';
import 'package:sudoku/Widgets/buttons/number_button.dart';
import 'package:sudoku/constants/usefull_tips_slideshow.dart';
import 'package:sudoku/models/sudoku_loader.dart';
import 'package:sudoku/services/firebase_manger.dart';
import 'package:sudoku/services/game_state_manager.dart';
import 'package:sudoku/functions/sudoku_points.dart';
import 'package:sudoku/functions/sudoku_validator.dart';
import 'package:sudoku/functions/sudoku_functions.dart';
import 'package:sudoku/widgets/buttons/tool_button.dart';
import 'package:unicons/unicons.dart';

class SudokuGrid extends StatefulWidget {
  const SudokuGrid({
    required this.difficulty,
    super.key,
  });
// ignore: prefer_typing_uninitialized_variables
  final difficulty;

  @override
  State<SudokuGrid> createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  final SudokuPoints _pointsManager = SudokuPoints();
  final List<List<int?>> _userFilledNumbers =
      List.generate(9, (_) => List<int?>.filled(9, null));

  final SudokuAudioPlayer _audioPlayer = SudokuAudioPlayer();

  late GlobalKey _repaintKey;
  late List<List<int?>> _sudokuGrid;
  late List<List<bool>> _userFilled;
  late List<List<List<int>>> _userPencilMarks;
  late List<Map<String, dynamic>> _moveHistory;
  late List<int> _remainingNumbers;
  late SudokuLoader _sudokuLoader;
  late Timer _timer;

  int? _selectedNumber;
  int? _selectedRow;
  int? _selectedCol;

  int _remainingHints = 3;
  int _mistakeCount = 0;
  int _secondsElapsed = 0;

  bool _isPencilActivated = false;
  bool _isPaused = false;
  bool _isTableLoading = true;
  bool _isGameSoundEnabled = true;

  bool _isGameWon() {
    return SudokuValidator(_sudokuGrid).isSudokuSolved();
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
    _startTimer();
    _sudokuLoader = SudokuLoader(
      _sudokuGrid,
      _userFilled,
      widget.difficulty,
    );
    _loadSudoku();
    _loadSoundSettings();
    _repaintKey = GlobalKey();
  }

  Future<void> _loadSoundSettings() async {
    final isGameSoundEnabled = await GameStateManager.loadGameSound();
    setState(() {
      _isGameSoundEnabled = isGameSoundEnabled;
    });
  }

  void _handleGameWon() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WinPage(
          totalTime: _formatTime(_secondsElapsed),
          difficultys: widget.difficulty,
          points: _pointsManager.points,
        );
      },
    ).then((_) async {
      if (_isGameWon()) {
        try {
          RenderRepaintBoundary boundary = _repaintKey.currentContext!
              .findRenderObject() as RenderRepaintBoundary;
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);

          if (byteData != null) {
            Uint8List screenshot = byteData.buffer.asUint8List();
            FirebaseManager.uploadGameResult(
              secondsElapsed: _secondsElapsed,
              difficulty: widget.difficulty,
              points: _pointsManager.points,
              mistakeCount: _mistakeCount,
              imageData: screenshot,
            );
          }
        } catch (e) {
          debugPrint('Error capturing and uploading screenshot: $e');
        }
      }
    });
    if (_isGameSoundEnabled == true) {
      _audioPlayer.playVictorySound();
    }
  }

  void _initializeState() {
    _sudokuGrid = List.generate(9, (_) => List<int?>.filled(9, null));
    _userFilled = List.generate(9, (_) => List<bool>.filled(9, false));
    _userPencilMarks = List.generate(9, (_) => List.generate(9, (_) => []));
    _moveHistory = [];
    _remainingNumbers = List<int>.generate(9, (_) => 9);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    GameStateManager.saveGameState(
      difficulty: widget.difficulty,
      remainingHints: _remainingHints,
      mistakeCount: _mistakeCount,
      secondsElapsed: _secondsElapsed,
    );

    GameStateManager.saveUserFilled(userFilled: _userFilled);

    GameStateManager.saveUserFilledNumbers(
        userFilledNumbers: _userFilledNumbers);

    GameStateManager.saveUserPencilMarks(userPencilMarks: _userPencilMarks);
  }

  Future<void> _loadSudoku() async {
    await _sudokuLoader.loadSudoku();
    setState(() {
      _isTableLoading = false;
    });
  }

// Start the timer
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (!_isPaused) {
          _secondsElapsed++;
        }
      });
    });
  }

//time format
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr =
        remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }

//undo
  void _handleUndo() {
    if (_moveHistory.isNotEmpty) {
      setState(() {
        final lastMove = _moveHistory.removeLast();
        final row = lastMove['row'];
        final col = lastMove['col'];
        final prevValue = lastMove['prevValue'];

        SudokuFunctions.undo(
          _sudokuGrid,
          _userFilled,
          _userFilledNumbers,
          row,
          col,
          prevValue,
        );
        _calculateRemainingNumbers();
      });
      if (_isGameSoundEnabled == true) {
        _audioPlayer.playButtonSound();
      }
    }
  }

//eraser
  void _handleEraser() {
    try {
      setState(() {
        // Clear both the filled number and pencil marks
        _sudokuGrid[_selectedRow!][_selectedCol!] = null;
        _userFilled[_selectedRow!][_selectedCol!] = false;
        _userFilledNumbers[_selectedRow!][_selectedCol!] = null;
        _userPencilMarks[_selectedRow!][_selectedCol!] = [];

        _calculateRemainingNumbers();
      });
      if (_isGameSoundEnabled == true) {
        _audioPlayer.playEraserSound();
      }
    } catch (e) {
      debugPrint('slect the table');
    }
  }

//Pencil
  void handlePencil(int number) {
    if (_selectedRow != null && _selectedCol != null) {
      setState(() {
        if (_userPencilMarks[_selectedRow!][_selectedCol!].contains(number)) {
          _userPencilMarks[_selectedRow!][_selectedCol!].remove(number);
        } else {
          _userPencilMarks[_selectedRow!][_selectedCol!].add(number);
        }

        _selectedNumber = null;
      });
      if (_isPencilActivated) {
        if (_isGameSoundEnabled == true) {
          _audioPlayer.playPencilSound();
        }
      }
    }
  }

//hintt
  void _handleHint(BuildContext context) {
    if (_remainingHints > 0) {
      SudokuFunctions.hint(
        _sudokuGrid,
        _userFilled,
        _userFilledNumbers, // Pass userFilledNumbers
        context,
        (int row, int col, int number) {
          setState(() {
            _remainingHints--;
          });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No more hints available!',
            style: Theme.of(context).snackBarTheme.contentTextStyle,
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        ),
      );
    }
  }

  void _calculateRemainingNumbers() {
    _remainingNumbers = List<int>.generate(9, (_) => 9);

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (_sudokuGrid[row][col] != null) {
          _remainingNumbers[_sudokuGrid[row][col]! - 1]--;
        }
      }
    }
  }

  Widget _numTiles(BuildContext context, int index) {
    int row = index ~/ 9;
    int col = index % 9;
    int? value = _sudokuGrid[row][col];

    bool isSelected = _selectedRow != null &&
        _selectedCol != null &&
        (_selectedRow == row || _selectedCol == col);
    bool isInSelectedSubgrid = _selectedRow != null &&
        _selectedCol != null &&
        _isInSelectedSubgrid(row, col);
    bool isEditable = value == null || _userFilled[row][col];
    bool isWrongNumber = _userFilled[row][col] &&
        value != null &&
        !SudokuValidator(_sudokuGrid).isValidPlacement(row, col, value);

    bool hasUserPencilMarks = _userPencilMarks[row][col].isNotEmpty;

    Color? cellColor = isWrongNumber
        ? Colors.redAccent
        : isSelected || isInSelectedSubgrid
            ? Theme.of(context).focusColor
            : Theme.of(context).colorScheme.secondary;

    Color? textColor = isWrongNumber
        ? Colors.white
        : isSelected || isInSelectedSubgrid
            ? Theme.of(context).colorScheme.primary
            : isEditable
                ? Colors.deepPurple[100]
                : Theme.of(context).colorScheme.onSurface;

    if (_selectedRow == row && _selectedCol == col) {
      cellColor = Theme.of(context).highlightColor;
      textColor = Colors.white;
    }

    if (_selectedNumber != null && value == _selectedNumber) {
      cellColor = Theme.of(context).hintColor;
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    if (!isEditable && hasUserPencilMarks) {
      _userPencilMarks[row][col] = [];
    }

    if (_userFilledNumbers[row][col] != null) {
      value = _userFilledNumbers[row][col];
      textColor = const Color.fromRGBO(115, 102, 227, 1);
      isEditable = true;
    }

    return GestureDetector(
      onTap: isEditable
          ? () {
              setState(() {
                if (_selectedRow == row && _selectedCol == col) {
                  _selectedRow = null;
                  _selectedCol = null;
                  _selectedNumber = null;
                } else {
                  _selectedRow = row;
                  _selectedCol = col;
                  _selectedNumber = value;
                }
              });
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).primaryColor,
              width: _getBorderWidth(row, true),
            ),
            left: BorderSide(
              color: Theme.of(context).primaryColor,
              width: _getBorderWidth(col, false),
            ),
            right: col == 8
                ? BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 1.0)
                : BorderSide.none,
            bottom: row == 8
                ? BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 1.0)
                : BorderSide.none,
          ),
          color: cellColor,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${value ?? ''}',
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight:
                      isWrongNumber ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isEditable && hasUserPencilMarks) _buildPencilMarks(row, col),
          ],
        ),
      ),
    );
  }

  Widget _buildPencilMarks(int row, int col) {
    bool isSelected = _selectedRow != null &&
        _selectedCol != null &&
        (_selectedRow == row || _selectedCol == col);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.transparent,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            int number = index + 1;
            bool isUserPencil = _userPencilMarks[row][col].contains(number);
            return Center(
              child: Text(
                isUserPencil ? '$number' : '',
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? Colors.white
                      : const Color.fromRGBO(115, 102, 227, 1),
                  fontFamily: 'PoppinsBold',
                ),
              ),
            );
          },
          itemCount: 9,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  double _getBorderWidth(int position, bool isRow) {
    if ((position % 3 == 0 && position > 0)) {
      return 3.5;
    }
    return 0.75;
  }

  bool _isInSelectedSubgrid(int row, int col) {
    if (_selectedRow == null || _selectedCol == null) {
      return false;
    }

    int subgridStartRow = (_selectedRow! ~/ 3) * 3;
    int subgridStartCol = (_selectedCol! ~/ 3) * 3;

    return row >= subgridStartRow &&
        row < subgridStartRow + 3 &&
        col >= subgridStartCol &&
        col < subgridStartCol + 3;
  }

  void _updateCell(int number) async {
    if (_selectedRow != null && _selectedCol != null) {
      bool isValid = await SudokuValidator(_sudokuGrid)
          .validateCell(_selectedRow!, _selectedCol!, number);

      if (isValid) {
        _pointsManager.correctMove();
        if (_isGameSoundEnabled == true) {
          _audioPlayer.playCorrectMoveSound();
        }
      } else {
        _pointsManager.wrongMove();
        if (_isGameSoundEnabled == true) {
          _audioPlayer.playWrongMoveSound();
        }
      }

      if (isValid) {
        _moveHistory.add({
          'row': _selectedRow!,
          'col': _selectedCol!,
          'prevValue': _sudokuGrid[_selectedRow!][_selectedCol!],
        });
      } else {
        _moveHistory.add({
          'row': _selectedRow!,
          'col': _selectedCol!,
          'prevValue': _sudokuGrid[_selectedRow!][_selectedCol!],
        });

        setState(() {
          _mistakeCount++;
        });
      }

      setState(() {
        if (isValid) {
          _sudokuGrid[_selectedRow!][_selectedCol!] = number;
          _userFilled[_selectedRow!][_selectedCol!] = false;
          _userFilledNumbers[_selectedRow!][_selectedCol!] = number;
        } else {
          _sudokuGrid[_selectedRow!][_selectedCol!] = number;
          _userFilled[_selectedRow!][_selectedCol!] = true;
          _userFilledNumbers[_selectedRow!][_selectedCol!];
        }

        _selectedRow = null;
        _selectedCol = null;
        _selectedNumber = null;
        _calculateRemainingNumbers();

        if (_isGameWon()) {
          _handleGameWon();
          _timer.cancel();
        }
      });

      if (!isValid) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong Sudoku move!'),
            duration: Duration(seconds: 1),
            backgroundColor: Color.fromRGBO(115, 102, 227, 1),
          ),
        );
      }
    }
  }

  void _updateSelectedNumber(int number) {
    setState(() {
      _selectedNumber = _selectedNumber == number ? null : number;
    });
  }

  Widget _numberButton(int number) {
    return NumberButton(
      number: number,
      isPencilActivated: _isPencilActivated,
      selectedNumber: _selectedNumber,
      remainingNumbers: _remainingNumbers,
      handlePencil: handlePencil,
      updateSelectedNumber: _updateSelectedNumber,
      updateCell: _updateCell,
    );
  }

  @override
  Widget build(BuildContext context) {
    _calculateRemainingNumbers();
    Size screenSize = MediaQuery.of(context).size;
    String formattedTime = _formatTime(_secondsElapsed);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _isTableLoading
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: Text(
                'Sudoku',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GNavigationBar()));
                },
                child: const Icon(
                  UniconsLine.angle_left_b,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      ).then((result) {
                        if (result != null && result) {
                          _loadSoundSettings();
                        }
                      });
                    },
                    child: const Icon(
                      Iconsax.setting,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              ],
              toolbarHeight: 90,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
            ),
      body: _isTableLoading
          ? const Center(child: SudokuLoadingBar())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 130,
                        //height: 60,
                        child: Text(
                          ' $formattedTime',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _togglePause();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                title: const Center(
                                  child: Text(
                                    'Game Paused',
                                    style: TextStyle(
                                      fontFamily: 'PoppinsSemiBold',
                                    ),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${widget.difficulty}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromRGBO(115, 102, 227, 1),
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Time: $formattedTime',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: const UsefulTipsSlideshow()),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            115, 102, 227, 1),
                                      ),
                                      onPressed: () {
                                        _togglePause();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Resume',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.pause_circle_rounded,
                          color: Color.fromRGBO(115, 102, 227, 1),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                //board
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                UniconsLine.exclamation_triangle,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '$_mistakeCount',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                UniconsLine.star,
                                size: 20,
                                color: Color.fromRGBO(115, 102, 227, 1),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${_pointsManager.points}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontFamily: 'PoppinsSemiBold'),
                              ),
                            ],
                          ),
                          Text(
                            ' ${widget.difficulty}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(115, 102, 227, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RepaintBoundary(
                      key: _repaintKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4.0,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 108, 108, 108)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                              )
                            ],
                          ),
                          child: SizedBox(
                            height: screenSize.width * 0.898,
                            width: screenSize.width * 0.9,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 9,
                              ),
                              itemBuilder: _numTiles,
                              itemCount: 81,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //tools
                ToolButtons(
                  isPencilActivated: _isPencilActivated,
                  onPencilPressed: () {
                    setState(() {
                      _isPencilActivated = !_isPencilActivated;
                    });
                  },
                  onUndoPressed: _handleUndo,
                  onEraserPressed: _handleEraser,
                  onHintPressed: () {
                    _handleHint(context);
                  },
                  remainingHints: _remainingHints,
                  theme: Theme.of(context),
                ),

                //Number buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 1; i <= 9; i++) _numberButton(i),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
