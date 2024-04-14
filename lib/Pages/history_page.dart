import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';
import 'package:sudoku/models/game_history_model.dart';
import 'package:unicons/unicons.dart';

class GameResultsScreen extends StatelessWidget {
  const GameResultsScreen({super.key});

  //time format
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr =
        remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const GNavigationBar()));
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
            size: 23,
          ),
        ),
        title: Center(
          child: Text('History',
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        actions: const [
          SizedBox(
            width: 50,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('game_results')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('results')
            .orderBy('registeredAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Column(
              children: [
                Lottie.asset('assets/json/no_record.json'),
                const Text('No record found..')
              ],
            ));
          }

          // Process snapshot data
          List<GameHistoryModel> gameResults = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return GameHistoryModel(
              time: data['time'] ?? 0,
              difficulty: data['difficulty'] ?? '',
              points: data['points'] ?? 0,
              mistakes: data['mistakes'] ?? 0,
              imageUrl: data['image_url'] ?? '',
            );
          }).toList();

          return ListView.builder(
            itemCount: gameResults.length,
            itemBuilder: (context, index) {
              GameHistoryModel result = gameResults[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Image.network(result.imageUrl),
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: result.imageUrl.isNotEmpty
                                ? Image.network(result.imageUrl,
                                    fit: BoxFit.cover)
                                : const Placeholder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                UniconsSolid.star,
                                size: 20,
                                color: Colors.amber,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${result.points}',
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                UniconsSolid.graph_bar,
                                size: 20,
                                color: Color.fromRGBO(115, 102, 227, 1),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                result.difficulty,
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                UniconsSolid.stopwatch,
                                size: 20,
                                color: Colors.cyanAccent,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 1,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                _formatTime(result.time),
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Icon(
                                UniconsSolid.exclamation_triangle,
                                size: 20,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${result.mistakes}',
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
