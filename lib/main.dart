import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/SplashScreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/Widgets/theme/theme_provider.dart';

Future<void> main() async {
  //firebase initallizing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Get device info
  String deviceId = await _getDeviceId();
  await _createOrSignInUser(deviceId);

  //
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            theme: themeProvider.themeData,
          );
        },
      ),
    ),
  );
}

Future<String> _getDeviceId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceId = '';

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    deviceId = androidInfo.androidId;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }

  return deviceId;
}

String _generateGameTag() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  String gameTag = '';

  for (int i = 0; i < 5; i++) {
    gameTag += chars[random.nextInt(chars.length)];
  }

  return gameTag;
}

Future<void> _createOrSignInUser(String deviceId) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    // ignore: unused_local_variable
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: '$deviceId@bingizSudoku.com',
      password: 'password',
    );
  } catch (e) {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: '$deviceId@bingizSudoku.com',
      password: 'password',
    );

    String defaultName = 'SudoSavvy';
    String gameTag = _generateGameTag();
    String imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/sudoku-4da6e.appspot.com/o/profile_icons%2Fmen_1.png?alt=media&token=2e5b4a65-fce9-49d2-9d92-a495ce3184c7';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'deviceId': deviceId,
      'name': defaultName,
      'gameTag': gameTag,
      'profileImageUrl': imageUrl,
      'registeredAt': DateTime.now(),
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
