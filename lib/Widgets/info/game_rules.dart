import 'package:flutter/material.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';

class SudokuRuleScreen extends StatefulWidget {
  const SudokuRuleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SudokuRuleScreenState createState() => _SudokuRuleScreenState();
}

class _SudokuRuleScreenState extends State<SudokuRuleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'Sudoku Rules',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color.fromRGBO(115, 102, 227, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset('assets/images/sudoku_logo.png'),
            const SizedBox(height: 20.0),
            const Text(
              '1. Each row, column, and 3x3 subgrid must contain all of the digits 1 through 9.',
              style: TextStyle(fontSize: 16.0, fontFamily: 'PoppinsSemiBold'),
            ),
            const SizedBox(height: 10.0),
            const Text(
              '2. No digit can be repeated within a row, column, or subgrid.',
              style: TextStyle(fontSize: 16.0, fontFamily: 'PoppinsSemiBold'),
            ),
            const SizedBox(height: 10.0),
            const Text(
              '3. A puzzle is solved when all cells are filled and the rules are obeyed.',
              style: TextStyle(fontSize: 16.0, fontFamily: 'PoppinsSemiBold'),
            ),
            const SizedBox(height: 20.0),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GNavigationBar()));
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                      color: Color.fromRGBO(115, 102, 227, 1), fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
