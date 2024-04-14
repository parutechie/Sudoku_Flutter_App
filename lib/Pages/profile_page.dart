// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sudoku/Pages/history_page.dart';
import 'package:sudoku/Pages/settings_page.dart';
import 'package:sudoku/services/firebase_manger.dart';
import 'package:sudoku/widgets/info/game_rules.dart';
import 'package:sudoku/widgets/info/howtoplay_info.dart';
import 'package:sudoku/widgets/info/about.dart';
import 'package:unicons/unicons.dart';
import 'package:android_intent/android_intent.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final String _profileImage = 'assets/profile_icons/men.png';

  String? userName;
  String? gametag;
  String? profileImageUrl;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchUserTags();
    fetchUserProfileImage();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _quitGame() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      const AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.HOME',
      );
      intent.launch();
    }
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

  void fetchUserTags() async {
    FirebaseOperations firebaseOperations = FirebaseOperations();
    String? name = await firebaseOperations.fetchUserTag();
    setState(() {
      gametag = name;
    });
  }

  void _editName() async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String editedName = '';
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            'Edit Name',
            style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              color: Color.fromRGBO(115, 102, 227, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            onChanged: (value) {
              editedName = value;
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(115, 102, 227, 1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(
                  UniconsLine.user,
                  color: Color.fromRGBO(115, 102, 227, 1),
                ),
                hintText: 'Enter your new name',
                hintStyle:
                    const TextStyle(color: Color.fromRGBO(115, 102, 227, 1))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(editedName);
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(115, 102, 227, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      // Update the name in Firebase
      await FirebaseOperations().updateUserName(newName);
      setState(() {
        userName = newName;
      });
    }
  }

  void _changeProfileImage() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from being dismissed
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Center(child: Text('Loading')),
            content: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
          );
        },
      );

      List<String> profileImages =
          await FirebaseManager.fetchProfileImagesFromFirestore();

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      String? newProfileImage = await showDialog<String>(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Select Avatar')),
            content: SizedBox(
              height: 400, // Adjust height as needed
              width: double.maxFinite,
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                children: profileImages.map((imageUrl) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, imageUrl);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );

      if (newProfileImage != null) {
        // Save the selected profile image URL in Firebase
        await FirebaseManager.updateUserProfileImage(newProfileImage);

        setState(() {
          profileImageUrl = newProfileImage;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error fetching profile images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'Profile',
          style: TextStyle(
              color: Color.fromRGBO(115, 102, 227, 1),
              fontFamily: 'PoppinsSemiBold'),
        )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    profileImageUrl != null
                        ? Image.network(
                            profileImageUrl!,
                            fit: BoxFit.cover,
                            scale: 4,
                          )
                        : Image.asset(
                            _profileImage,
                            scale: 4,
                          ),
                    Positioned(
                      bottom: 4,
                      right: 5,
                      child: GestureDetector(
                        onTap: _changeProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(115, 102, 227, 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$userName',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '#$gametag',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              //quit
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _editName();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.edit_2,
                              size: 30,
                              color: Color.fromRGBO(115, 102, 227, 1),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Edit Name',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Iconsax.arrow_right_3,
                        color: Colors.deepPurple,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.setting,
                                  size: 30,
                                  color: Color.fromRGBO(115, 102, 227, 1),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Game Settings',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Color.fromRGBO(115, 102, 227, 1),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GameResultsScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  UniconsLine.history,
                                  size: 30,
                                  color: Color.fromRGBO(115, 102, 227, 1),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'History',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Color.fromRGBO(115, 102, 227, 1),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlayInfo()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  UniconsLine.file,
                                  size: 30,
                                  color: Color.fromRGBO(115, 102, 227, 1),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'How to Play',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Color.fromRGBO(115, 102, 227, 1),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SudokuRuleScreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  UniconsLine.book_open,
                                  size: 30,
                                  color: Color.fromRGBO(115, 102, 227, 1),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Game Rules',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Color.fromRGBO(115, 102, 227, 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //Next
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutGame()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  UniconsLine.info_circle,
                                  size: 30,
                                  color: Color.fromRGBO(115, 102, 227, 1),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'About Game',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Color.fromRGBO(115, 102, 227, 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //quit
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _quitGame,
                        child: const Row(
                          children: [
                            Icon(
                              UniconsLine.signout,
                              size: 30,
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Quit Game',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PoppinsSemiBold',
                                  color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Iconsax.arrow_right_3,
                        color: Colors.redAccent,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
