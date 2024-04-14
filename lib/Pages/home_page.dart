// ignore: file_names
import 'package:flutter/material.dart';
import 'package:sudoku/Models/quest_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sudoku/Pages/history_page.dart';
import 'package:sudoku/Pages/leaderboard_page.dart';
import 'package:sudoku/Services/firebase_manger.dart';
import 'package:sudoku/Widgets/info/howtoplay_info.dart';
import 'package:sudoku/constants/difficulty_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController firstAniCon;
  late Animation firstAni;
  late final String _profileImage = 'assets/profile_icons/men.png';

  String? userName;
  String? profileImageUrl;

  @override
  void initState() {
    firstAniCon = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
    );
    firstAni = Tween<double>(begin: 0.741, end: 0).animate(
      CurvedAnimation(
        parent: firstAniCon,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
    fetchUserName();
    fetchUserProfileImage();
    super.initState();
  }

  void fetchUserName() async {
    FirebaseOperations firebaseOperations = FirebaseOperations();
    String? name = await firebaseOperations.fetchUserName();
    setState(() {
      userName = name;
    });
  }

  void fetchUserProfileImage() async {
    FirebaseOperations firebaseOperations = FirebaseOperations();
    String? imageUrl = await firebaseOperations.fetchUserProfileImage();
    if (imageUrl != null) {
      setState(() {
        profileImageUrl = imageUrl;
      });
    }
  }

  String formatMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  String _formatDate() {
    DateTime currentDate = DateTime.now();

    String formattedDate =
        '${currentDate.day.toString().padLeft(2, '0')} ${formatMonth(currentDate.month)} ${currentDate.year.toString().padLeft(2, '0')}  ';

    return formattedDate;
  }

  void _openCalendar(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuestModel(
          selectedDate: currentDate,
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstAniCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //profile_pic
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: profileImageUrl != null
                            ? Image.network(
                                profileImageUrl!,
                                fit: BoxFit.cover,
                                scale: 4,
                              )
                            : Image.asset(_profileImage),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello,',
                            style: TextStyle(
                              fontFamily: 'PoppinsSemiBold',
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '$userName',
                            style: const TextStyle(
                              fontFamily: 'PoppinsBold',
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            //daily quest
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 200,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        image: const DecorationImage(
                          image: AssetImage('assets/game_assets/card.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Daily Quest",
                                      style: TextStyle(
                                        fontFamily: 'PoppinsBold',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      _formatDate(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    // Figma Flutter Generator Rectangle132Widget - RECTANGLE
                                    GestureDetector(
                                      onTap: () {
                                        _openCalendar(context);
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 37,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(19),
                                            topRight: Radius.circular(19),
                                            bottomLeft: Radius.circular(19),
                                            bottomRight: Radius.circular(19),
                                          ),
                                          color:
                                              Color.fromRGBO(136, 125, 231, 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Play',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Image.asset('assets/images/card_image.png',
                                width: 170, height: 170),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Tips",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const <Widget>[
                    LeaderBoardCard(),
                    HistoryCard(),
                    HowToCard(),
                  ],
                ),
              ),
            ),
            Divider(
              indent: 50,
              endIndent: 50,
              thickness: 2,
              color: Theme.of(context).shadowColor,
            ),

            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        transitionAnimationController: firstAniCon,
                        context: context,
                        builder: (BuildContext context) => StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color.fromARGB(255, 207, 207, 207),
                                  ),
                                ],
                              ),
                              child: const DifficultySelectionPage(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 65,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'New Game',
                          style: TextStyle(
                            fontFamily: 'PoppinsBold',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
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

class LeaderBoardCard extends StatelessWidget {
  const LeaderBoardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LeaderBoardPage(),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 180,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Leaderboard',
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.white,
                    fontSize: 15),
              ),
              const SizedBox(
                height: 5,
              ),
              SvgPicture.asset(
                'assets/images/podium_homepage.svg',
                semanticsLabel: 'asd',
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 50,
                height: 27,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19),
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                  color: Color.fromRGBO(136, 125, 231, 1),
                ),
                child: const Center(
                  child: Text(
                    'Go',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GameResultsScreen(),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 180,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SvgPicture.asset(
                'assets/game_assets/howtoplay.svg',
                semanticsLabel: 'asd',
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 50,
                height: 27,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19),
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                  color: Color.fromRGBO(136, 125, 231, 1),
                ),
                child: const Center(
                  child: Text(
                    'Go',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HowToCard extends StatelessWidget {
  const HowToCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PlayInfo(),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 180,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'How-To',
                style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SvgPicture.asset(
                'assets/game_assets/how_to.svg',
                semanticsLabel: 'asd',
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 50,
                height: 27,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19),
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                  color: Color.fromRGBO(136, 125, 231, 1),
                ),
                child: const Center(
                  child: Text(
                    'Go',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
