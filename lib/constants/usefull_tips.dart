import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UsefulTips {
  static UsefulTipModel getRandomUsefulTip() {
    _getUsefulTips.shuffle();
    return _getUsefulTips[0];
  }

  static final List<UsefulTipModel> _getUsefulTips = [
    UsefulTipModel(
      title: "Statistics",
      description: "Easily track your progress with detailed statistics",
      iconData: Iconsax.activity,
      color: const Color.fromRGBO(115, 102, 227, 1),
    ),
    UsefulTipModel(
      title: "Settings",
      description: "Make the game more comfortable for you",
      iconData: Iconsax.setting,
      color: Colors.deepPurple,
    ),
    UsefulTipModel(
      title: "Difficulty",
      description: "Choose the difficulty that suits you best",
      iconData: Icons.gamepad,
      color: Colors.deepPurple.shade300,
    ),
    UsefulTipModel(
      title: "Timer",
      description: "Track your time and try to beat your best time",
      iconData: Icons.timer,
      color: const Color.fromRGBO(115, 102, 227, 1),
    ),
    UsefulTipModel(
      title: "Pencil",
      description: "Use pencil's which help you solve the puzzle",
      iconData: Iconsax.edit,
      color: Colors.deepPurple,
    ),
    UsefulTipModel(
      title: "Mistakes",
      description: "Try to solve the puzzle without mistakes",
      iconData: Icons.error,
      color: const Color.fromRGBO(115, 102, 227, 1),
    ),
  ];

  static List<UsefulTipModel> get usefulTips => _getUsefulTips;
}

class UsefulTipModel {
  String title;
  String description;
  IconData iconData;
  Color color;

  UsefulTipModel({
    required this.title,
    required this.description,
    required this.iconData,
    required this.color,
  });
}
