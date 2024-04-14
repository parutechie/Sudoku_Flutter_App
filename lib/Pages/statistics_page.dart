import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unicons/unicons.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: difficulties.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          automaticallyImplyLeading: false,
          title: const Center(
              child: Text(
            'Statistics',
            style: TextStyle(
                color: Color.fromRGBO(115, 102, 227, 1),
                fontFamily: 'PoppinsSemiBold'),
          )),
          bottom: TabBar(
            labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            labelColor: Theme.of(context).colorScheme.primary,
            dividerColor: Theme.of(context).scaffoldBackgroundColor,
            tabs: difficulties
                .map((difficulty) => Tab(text: difficulty))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: difficulties.map((difficulty) {
            return StatisticsSheet(
              difficulty: difficulty,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class StatisticsSheet extends StatelessWidget {
  final String difficulty;

  const StatisticsSheet({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('game_results')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('results')
          .where('difficulty', isEqualTo: difficulty)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final documents = snapshot.data!.docs;
        final statistics = calculateStatistics(documents);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Game',
                    style: TextStyle(
                        fontSize: 17, color: Color.fromRGBO(115, 102, 227, 1)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    UniconsLine.award,
                                    size: 32,
                                    color: Color.fromRGBO(115, 102, 227, 1),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Game won',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${statistics['gamesWon']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            /////////
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Points',
                    style: TextStyle(
                        fontSize: 17, color: Color.fromRGBO(115, 102, 227, 1)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Iconsax.star_1,
                                    size: 32,
                                    color: Color.fromRGBO(115, 102, 227, 1),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Total Points ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${statistics['totalPoints']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            ////
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Time',
                    style: TextStyle(
                        fontSize: 17, color: Color.fromRGBO(115, 102, 227, 1)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    UniconsLine.stopwatch,
                                    size: 35,
                                    color: Color.fromRGBO(115, 102, 227, 1),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Best Time',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                formatTime(statistics['bestTime'] as int),
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: 'PoppinsBold'),
                              ),
                            ],
                          ),
                        ),

                        //
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Iconsax.timer_14,
                                    size: 32,
                                    color: Color.fromRGBO(115, 102, 227, 1),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Average Time',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                formatTime(statistics['averageTime'] as int),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic> calculateStatistics(
      List<QueryDocumentSnapshot> documents) {
    int gamesWon = 0;
    int totalPoints = 0;
    int totalTime = 0;
    int totalGames = documents.length;
    int bestTime = 99999999;

    for (var doc in documents) {
      final data = doc.data() as Map<String, dynamic>;
      final points = data['points'] as int? ?? 0;
      final time = data['time'] as int? ?? 0;
      final gameWon = data['gameWon'] as bool? ?? false;

      totalPoints += points;
      totalTime += time;
      if (time < bestTime) {
        bestTime = time;
      }
      if (gameWon) {
        // If game is won, increment gamesWon counter
        gamesWon++;
      }
    }

    final averageTime = totalGames > 0 ? totalTime ~/ totalGames : 0;

    return {
      'totalPoints': totalPoints,
      'averageTime': averageTime,
      'bestTime': totalGames > 0 ? bestTime : 0,
      'gamesWon': gamesWon, // Return 0 if no games
    };
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

const List<String> difficulties = [
  'Easy',
  'Medium',
  'Hard',
  'Expert',
  'Master'
];
