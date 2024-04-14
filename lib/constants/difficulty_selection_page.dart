import 'package:flutter/material.dart';
import 'package:sudoku/models/sudoku_grid.dart';

class DifficultySelectionPage extends StatefulWidget {
  // ignore: use_super_parameters
  const DifficultySelectionPage({Key? key}) : super(key: key);

  get startTimer => null;

  @override
  // ignore: library_private_types_in_public_api
  _DifficultySelectionPageState createState() =>
      _DifficultySelectionPageState();
}

class _DifficultySelectionPageState extends State<DifficultySelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _verticalPosition;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _verticalPosition = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, _verticalPosition.value * 300),
          child: Opacity(
            opacity: _opacity.value,
            child: buildSheet(),
          ),
        );
      },
    );
  }

  Widget buildSheet() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose Complexity',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            tileColor: Colors.deepPurple[300],
            title: const Row(
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: Color.fromRGBO(115, 102, 227, 1),
                  size: 16.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Easy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              if (widget.startTimer != null) {
                widget.startTimer!();
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SudokuGrid(
                      difficulty: 'Easy',
                    ),
                  ));
            },
          ),
          ListTile(
            tileColor: Colors.deepPurple[300],
            title: const Row(
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: Color.fromRGBO(115, 102, 227, 1),
                  size: 16.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Medium',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SudokuGrid(
                      difficulty: 'Medium',
                    ),
                  ));
            },
          ),
          ListTile(
            tileColor: Colors.deepPurple[300],
            title: const Row(
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: Color.fromRGBO(115, 102, 227, 1),
                  size: 16.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Hard',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SudokuGrid(
                      difficulty: 'Hard',
                    ),
                  ));
            },
          ),
          ListTile(
            tileColor: Colors.deepPurple[300],
            title: const Row(
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: Color.fromRGBO(115, 102, 227, 1),
                  size: 16.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Expert',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SudokuGrid(
                      difficulty: 'Expert',
                    ),
                  ));
            },
          ),
          ListTile(
            tileColor: Colors.deepPurple[300],
            title: const Row(
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: Color.fromRGBO(115, 102, 227, 1),
                  size: 16.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Master',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SudokuGrid(
                    difficulty: 'Master',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
