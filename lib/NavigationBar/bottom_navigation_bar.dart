import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sudoku/Pages/home_page.dart';
import 'package:sudoku/Pages/profile_page.dart';
import 'package:sudoku/Pages/statistics_page.dart';

class GNavigationBar extends StatefulWidget {
  const GNavigationBar({super.key});

  @override
  State<GNavigationBar> createState() => _GNavigationBarState();
}

class _GNavigationBarState extends State<GNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatisticsPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                color: Colors.white,
                activeColor: Colors.white,
                haptic: true,
                tabBackgroundColor: Colors.white54.withOpacity(0.1),
                padding: const EdgeInsets.all(15),
                gap: 10,
                tabs: const [
                  GButton(
                    icon: Iconsax.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Iconsax.activity,
                    text: 'Statistics',
                  ),
                  GButton(
                    icon: Iconsax.profile_circle5,
                    text: 'Profile',
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
