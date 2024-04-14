import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FirebaseManager {
  static Future<void> uploadGameResult({
    required int secondsElapsed,
    required String difficulty,
    required int points,
    required int mistakeCount,
    required Uint8List imageData, // New parameter for image data
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String gameId = FirebaseFirestore.instance
            .collection('game_results')
            .doc(user.uid)
            .collection('results')
            .doc()
            .id;

        String imagePath = 'game_results/${user.uid}/$gameId.png';
        await firebase_storage.FirebaseStorage.instance
            .ref(imagePath)
            .putData(imageData);

        String imageUrl = await firebase_storage.FirebaseStorage.instance
            .ref(imagePath)
            .getDownloadURL();

        CollectionReference userGameResultsRef = FirebaseFirestore.instance
            .collection('game_results')
            .doc(user.uid)
            .collection('results');

        await userGameResultsRef.doc(gameId).set({
          'time': secondsElapsed,
          'difficulty': difficulty,
          'points': points,
          'mistakes': mistakeCount,
          'image_url': imageUrl,
          'gameWon': true,
          'registeredAt': DateTime.now(),
        });
      }
    } catch (e) {
      debugPrint('Error uploading game result to Firebase: $e');
    }
  }

  static Future<void> uploadQuestGameResult({
    required int secondsElapsed,
    required int points,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      String? gameTag = await FirebaseOperations().fetchUserTag();
      String? userName = await FirebaseOperations().fetchUserName();
      String? profileImageUrl =
          await FirebaseOperations().fetchUserProfileImage();

      if (gameTag == null) {
        return;
      }

      await FirebaseFirestore.instance
          .collection('quest_results')
          .doc(user.uid)
          .set({
        'name': userName,
        'gameTag': gameTag,
        'time': secondsElapsed,
        'points': points,
        'profileImageUrl': profileImageUrl,
        'registeredAt': DateTime.now(),
      });
    } catch (e) {
      debugPrint('Error uploading game result to Firebase: $e');
    }
  }

  static Future<void> updateUserProfileImage(String newImageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': newImageUrl});
    } catch (e) {
      debugPrint('Error updating user profile image: $e');
    }
  }

  static Future<List<String>> fetchProfileImagesFromFirestore() async {
    try {
      firebase_storage.ListResult result = await firebase_storage
          .FirebaseStorage.instance
          .ref('profile_icons')
          .listAll();

      List<String> profileImages = [];

      for (var item in result.items) {
        String imageUrl = await item.getDownloadURL();
        profileImages.add(imageUrl);
      }

      return profileImages;
    } catch (e) {
      // Handle error
      debugPrint('Error fetching profile images from Firebase Storage: $e');
      return [];
    }
  }
}

class FirebaseOperations {
  Future<String?> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }

      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data();
        if (userData != null && userData.containsKey('name')) {
          var name = userData['name'];
          if (name is String) {
            return name;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchUserTag() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }

      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data();
        if (userData != null && userData.containsKey('gameTag')) {
          var gameTag = userData['gameTag'];
          if (gameTag is String) {
            return gameTag;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchUserProfileImage() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }

      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data();
        if (userData != null && userData.containsKey('profileImageUrl')) {
          var profileImageUrl = userData['profileImageUrl'];
          if (profileImageUrl is String) {
            return profileImageUrl;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserName(String newName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': newName});
    } catch (e) {
      return;
    }
  }
}
