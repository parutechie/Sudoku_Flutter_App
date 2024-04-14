import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';

class DailyQuestWinPage extends StatefulWidget {
  final String totalTime;
  final int points;

  const DailyQuestWinPage({
    super.key,
    required this.totalTime,
    required this.points,
  });

  @override
  State<DailyQuestWinPage> createState() => _DailyQuestWinPageState();
}

class _DailyQuestWinPageState extends State<DailyQuestWinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Lottie.asset(
                'assets/json/Confetti.json',
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Center(
                    child: Container(
                      child: Lottie.asset('assets/json/trophys.json',
                          repeat: false, width: 300, height: 300),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Daily Quest Completed',
                        style: TextStyle(
                          color: Color.fromRGBO(115, 102, 227, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Congratulations!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                                // You can specify color here if needed
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "You've Solved the Daily Quest Puzzle in ",
                                ),
                                TextSpan(
                                  text: widget.totalTime,
                                  style: const TextStyle(
                                    fontFamily: 'PoppinsBold',
                                    color: Color.fromRGBO(115, 102, 227, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: " with ",
                                ),
                                TextSpan(
                                  text: "${widget.points}",
                                  style: const TextStyle(
                                    fontFamily: 'PoppinsBold',
                                    color: Color.fromRGBO(115, 102, 227, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: " points",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GNavigationBar(),
                      ),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(115, 102, 227, 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        'Home',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
