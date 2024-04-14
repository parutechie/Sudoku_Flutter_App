import 'package:flutter/material.dart';

class SudokuLoadingBar extends StatefulWidget {
  const SudokuLoadingBar({super.key});

  @override
  State<SudokuLoadingBar> createState() => _SudokuLoadingBarState();
}

class _SudokuLoadingBarState extends State<SudokuLoadingBar>
    with SingleTickerProviderStateMixin {
  List<List<int>> sudokuBoard = [
    [5, 3, 0, 0, 7, 0, 0, 0, 8],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 5, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [1, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  9,
                  (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        9,
                        (col) {
                          return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(115, 102, 227, 1)),
                              color: sudokuBoard[row][col] == 0
                                  ? Colors.transparent
                                  : const Color.fromRGBO(115, 102, 227, 1)
                                      .withOpacity(_animation.value),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //Text
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 15.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: const [
                    TextSpan(
                      text: 'cooking your ',
                    ),
                    TextSpan(
                      text: 'Sudoku',
                      style: TextStyle(
                        fontFamily: 'PoppinsBold',
                        color: Color.fromRGBO(115, 102, 227, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' puzzle... ',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
