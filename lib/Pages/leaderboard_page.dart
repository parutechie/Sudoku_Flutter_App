import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';
import 'package:unicons/unicons.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  List<Map<String, dynamic>> questResults = [];

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr =
        remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }

  String _formatRemainingTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    String hoursStr = hours < 10 ? '0$hours' : '$hours';
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';

    return '${hoursStr}hr ${minutesStr}min';
  }

  @override
  void initState() {
    super.initState();
    _remainingTimeUntilNextLeaderboard();
    fetchQuestResultsForDate(
        DateTime.now()); // Fetch results for today initially
  }

  Duration _remainingTimeUntilNextLeaderboard() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    Duration remainingTime = endOfDay.difference(now);
    return remainingTime;
  }

  Future<void> fetchQuestResultsForDate(DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = startDate.add(const Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('quest_results')
              .where('registeredAt', isGreaterThanOrEqualTo: startDate)
              .where('registeredAt', isLessThan: endDate)
              .get();

      // Clear the questResults list before updating it
      questResults.clear();

      // Fetch the user profile image URL for each document asynchronously
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        // Read the profile image URL directly from the Firestore document
        String? profileImageUrl = data[
            'profileImageUrl']; // Assuming this is the field name in your Firestore document
        questResults.add({...data, 'profileImageUrl': profileImageUrl});
      }

      // Sort the questResults list
      questResults.sort((a, b) {
        int timeComparison = a['time'].compareTo(b['time']);
        if (timeComparison != 0) {
          return timeComparison;
        }
        return b['points'].compareTo(a['points']);
      });

      // Update the UI
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching quest results: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration remainingTime = _remainingTimeUntilNextLeaderboard();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GNavigationBar()));
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        'Leaderboard',
                        style: TextStyle(
                            fontFamily: 'PoppinsSemiBold',
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 500,
                  height: 500,
                  child: SvgPicture.asset(
                    'assets/game_assets/Podium.svg',
                    semanticsLabel: 'podium',
                  ),
                ),
              ],
            ),
            Positioned(
              top: 50,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      UniconsSolid.clock,
                      color: Colors.deepPurpleAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _formatRemainingTime(remainingTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //2ns
            Positioned(
              top: 115,
              left: 10,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(50),
                        image: questResults.isNotEmpty &&
                                questResults.length > 1
                            ? DecorationImage(
                                image: NetworkImage(
                                    questResults[1]['profileImageUrl'] ?? ''),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          questResults.isNotEmpty && questResults.isNotEmpty
                              ? questResults[1]['name'] ?? 'Unknown'
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          questResults.isNotEmpty && questResults.isNotEmpty
                              // ignore: prefer_interpolation_to_compose_strings
                              ? '#' + questResults[1]['gameTag']
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 98,
              left: 68,
              width: 35,
              height: 35,
              child: SvgPicture.asset(
                'assets/game_assets/badge_2.svg',
                semanticsLabel: 'badge_2',
              ),
            ),

            //1st
            Positioned(
              top: 80,
              left: 133,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(50),
                        image: questResults.isNotEmpty &&
                                questResults.length > 1
                            ? DecorationImage(
                                image: NetworkImage(
                                    questResults[0]['profileImageUrl'] ?? ''),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          questResults.isNotEmpty && questResults.isNotEmpty
                              ? questResults[0]['name'] ?? 'Unknown'
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          questResults.isNotEmpty && questResults.isNotEmpty
                              // ignore: prefer_interpolation_to_compose_strings
                              ? '#' + questResults[0]['gameTag']
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 65,
              left: 192,
              width: 35,
              height: 35,
              child: SvgPicture.asset(
                'assets/game_assets/badge_1.svg',
                semanticsLabel: 'badge_1',
              ),
            ),

            //3rd
            Positioned(
              top: 150,
              left: 255,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(50),
                        image: questResults.isNotEmpty &&
                                questResults.length > 1
                            ? DecorationImage(
                                image: NetworkImage(
                                    questResults[2]['profileImageUrl'] ?? ''),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          questResults.isNotEmpty && questResults.isNotEmpty
                              ? questResults[2]['name'] ?? 'Unknown'
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          questResults.isNotEmpty && questResults.isNotEmpty
                              // ignore: prefer_interpolation_to_compose_strings
                              ? '#' + questResults[2]['gameTag']
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 135,
              left: 313,
              width: 35,
              height: 35,
              child: SvgPicture.asset(
                'assets/game_assets/badge_3.svg',
                semanticsLabel: 'badge_3',
              ),
            ),

            Positioned(
              top: 410,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: questResults.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final result = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Container(
                        height: 80,
                        width: 370,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$index',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              result['profileImageUrl']),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          result['name'] ?? 'Unknown',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '#${result['gameTag'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Time',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              _formatTime(result['time'] ?? 0),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .canvasColor),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Points',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              result['points'].toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .canvasColor),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
