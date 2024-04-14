import 'package:flutter/material.dart';
import 'package:sudoku/constants/usefull_tips.dart';

class UsefulTipsSlideshow extends StatefulWidget {
  const UsefulTipsSlideshow({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UsefulTipsSlideshowState createState() => _UsefulTipsSlideshowState();
}

class _UsefulTipsSlideshowState extends State<UsefulTipsSlideshow> {
  int _currentIndex = 0;
  late List<UsefulTipModel> _tips;

  @override
  void initState() {
    super.initState();
    _tips = List.from(UsefulTips.usefulTips); // Copy the list of tips
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swiped right, show previous tip
          setState(() {
            _currentIndex = (_currentIndex - 1) % _tips.length;
          });
        } else if (details.primaryVelocity! < 0) {
          // Swiped left, show next tip
          setState(() {
            _currentIndex = (_currentIndex + 1) % _tips.length;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                _tips[_currentIndex].iconData,
                color: _tips[_currentIndex].color,
                size: 25,
              ),
              title: Center(
                child: Text(
                  _tips[_currentIndex].title,
                  style: const TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _tips[_currentIndex].description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    return List.generate(
      _tips.length,
      (index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.fiber_manual_record,
            size: 12,
            color: index == _currentIndex
                ? const Color.fromRGBO(115, 102, 227, 1)
                : Colors.grey[300],
          ),
        );
      },
    );
  }
}
