// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:sudoku/NavigationBar/bottom_navigation_bar.dart';
import 'package:sudoku/OnboardingScreen/onboard_content.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final data = [
    OnBoardContent(
        title: 'Sudoku - Ultimate Brain Teaser',
        subtitle: ' Test Your Brainpower with the Ultimate Challenge!',
        image: SizedBox(
            width: 300,
            height: 400,
            child: Lottie.asset('assets/json/welcome.json')),
        backgroundColor: Colors.white,
        titleColor: Colors.black,
        subtitleColor: Colors.black),
    OnBoardContent(
      title: '',
      subtitle:
          'Unlock the Table Trove: 2000+ Tables Ready for Your Gaming Adventure!',
      image: SizedBox(
          width: 300,
          height: 400,
          child: Lottie.asset('assets/json/user.json')),
      backgroundColor: Colors.black,
      titleColor: const Color.fromRGBO(115, 102, 227, 1),
      subtitleColor: const Color.fromRGBO(115, 102, 227, 1),
    ),
    OnBoardContent(
      title: '',
      subtitle:
          'Unleash Your Brainpower with Sudoku: Let the Ultimate Challenge Begin!',
      image: SizedBox(
          width: 300,
          height: 400,
          child: Lottie.asset('assets/json/square.json')),
      backgroundColor: const Color.fromRGBO(115, 102, 227, 1),
      titleColor: Colors.white,
      subtitleColor: Colors.white,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (!isFirstTime) {
      // If it's not the first time, navigate directly to the GNavigationBar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GNavigationBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        itemCount: data.length,
        colors: data.map((e) => e.backgroundColor).toList(),
        physics: const NeverScrollableScrollPhysics(),
        nextButtonBuilder: (context) => const Padding(
          padding: EdgeInsets.only(left: 3),
          child: Icon(
            Icons.navigate_next,
            size: 30,
          ),
        ),
        itemBuilder: (int index) {
          return CardUIView(data: data[index]);
        },
        onChange: (index) {},
        onFinish: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstTime', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const GNavigationBar()),
          );
        },
      ),
    );
  }
}
