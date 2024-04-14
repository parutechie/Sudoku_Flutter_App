import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AboutGame extends StatefulWidget {
  const AboutGame({super.key});

  @override
  State<AboutGame> createState() => _AboutGameState();
}

class _AboutGameState extends State<AboutGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: const Center(
          child: Text(
            'About Game',
            style: TextStyle(
                fontFamily: 'PoppinsBold', fontSize: 20, color: Colors.white),
          ),
        ),
        actions: const [
          SizedBox(
            width: 50,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/sudoku_logo.png',
                  scale: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Sudoku',
                  style: TextStyle(fontSize: 35, fontFamily: 'PoppinsSemiBold'),
                ),
                const Text(
                  'Version 1.2.2',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'PoppinsBold',
                      color: Color.fromRGBO(115, 102, 227, 1)),
                ),
              ],
            ),
            const Column(
              children: [
                Icon(
                  UniconsLine.copyright,
                  color: Color.fromRGBO(115, 102, 227, 1),
                ),
                Text(
                  '© 2024 Bingiz Ltd',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'PoppinsSemiBold',
                  ),
                ),
                Text(
                  'All rights reserved',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'PoppinsSemiBold',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
