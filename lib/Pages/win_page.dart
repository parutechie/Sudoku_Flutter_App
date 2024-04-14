import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';
import 'package:unicons/unicons.dart';

class WinPage extends StatefulWidget {
  final String totalTime;
  final String difficultys;
  final int points;

  const WinPage({
    super.key,
    required this.totalTime,
    required this.difficultys,
    required this.points,
  });

  @override
  State<WinPage> createState() => _WinPageState();
}

class _WinPageState extends State<WinPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Congratulations!',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(child: Text("You've Solved the Puzzle")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(UniconsSolid.star,
                                    color: Color.fromRGBO(115, 102, 227, 1)),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Points'),
                              ],
                            ),
                            Text('${widget.points}')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(UniconsSolid.graph_bar,
                                    color: Color.fromRGBO(115, 102, 227, 1)),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Difficulty'),
                              ],
                            ),
                            Text(widget.difficultys)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(UniconsSolid.stopwatch,
                                    color: Color.fromRGBO(115, 102, 227, 1)),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Time'),
                              ],
                            ),
                            Text(widget.totalTime)
                          ],
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
