import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';
import 'package:sudoku/widgets/info/game_play_content.dart';

class PlayInfo extends StatefulWidget {
  const PlayInfo({super.key});

  @override
  State<PlayInfo> createState() => _PlayInfoState();
}

class _PlayInfoState extends State<PlayInfo> {
  final pages = [
    const ContentView(
      contentBackgroundColor: Colors.white,
      imageUrls: 'assets/game_assets/Table1.png',
      description:
          'A Sudoku Puzzle begins with a grid in which some of the numbers are already in place. A Puzzle is completed when each number from 1 to 9 appears only once in each of the 9 rows, columns, and blocks. Study the grid to find the numbers that might fit into each cell',
    ),
    const ContentView(
        contentBackgroundColor: Colors.white,
        imageUrls: 'assets/game_assets/fill_table.png',
        description: 'Select a Cell, then tap a number to fill in the cell'),
    const ContentView(
        contentBackgroundColor: Colors.white,
        imageUrls: 'assets/game_assets/notes.png',
        description: 'Toggle Notes Mode to add and remove notes'),
    const ContentView(
        contentBackgroundColor: Colors.white,
        imageUrls: 'assets/game_assets/hint.png',
        description:
            "Can't be solved? Using Hint can help you through difficulties!"),
  ];

  final _controller = LiquidController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'How to Play',
          style: TextStyle(fontSize: 25, fontFamily: 'PoppinsBold'),
        )),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            LiquidSwipe(
              pages: pages,
              liquidController: _controller,
              onPageChangeCallback: (index) {
                setState(() {
                  isLastPage = index == pages.length - 1;
                });
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(page: pages.length - 1);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          color: Color.fromRGBO(115, 102, 227, 1)),
                    ),
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: _controller.currentPage,
                    count: pages.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: Color.fromRGBO(115, 102, 227, 1),
                      activeDotColor: Color.fromRGBO(115, 102, 227, 1),
                    ),
                    onDotClicked: (index) {
                      _controller.animateToPage(page: index);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      if (isLastPage) {
                        // Navigate to another page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GNavigationBar()),
                        );
                      } else {
                        final page = _controller.currentPage + 1;
                        _controller.animateToPage(
                            page: page > pages.length ? 0 : page,
                            duration: 480);
                      }
                    },
                    child: Text(
                      isLastPage ? 'Done' : 'Next',
                      style: const TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          color: Color.fromRGBO(115, 102, 227, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
