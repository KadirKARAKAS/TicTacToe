import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tic_tac_toe/constant.dart';
import 'package:tic_tac_toe/FirstOpeningPage/Page/first_opening_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleAppStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _handleAppStart() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      await _signInAnonymouslyAndSavePlatformData();
      _navigateToStartGame();
    } else {
      await _loadUserData();
      _navigateToNextPageBasedOnPets();
    }
  }

  Future<void> _signInAnonymouslyAndSavePlatformData() async {
    await FirebaseAuth.instance.signInAnonymously();

    final mapSaveData = {'Platform': Platform.isIOS ? 'iOS' : 'Android'};

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(mapSaveData);
  }

  void _navigateToStartGame() {
    Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.fade,
        child: FirstOpeningPage(),
        duration: Duration(milliseconds: 1250),
      ),
    );
  }

  Future<void> _loadUserData() async {
    final userRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final pastMatchesSnapshot = await userRef.collection("Games").get();
    pastMatches.addAll(pastMatchesSnapshot.docs.map((doc) => doc.data()));

    pastMatches.clear();
    final pastSnapshot = await userRef.collection("Games").get();
    pastMatches.addAll(pastSnapshot.docs.map((doc) => doc.data()));
  }

  void _navigateToNextPageBasedOnPets() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (pastMatches.isEmpty) {
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.fade,
            child: FirstOpeningPage(),
            duration: Duration(milliseconds: 1250),
          ),
        );
        print("GEÇMİŞ MAÇ BULUNAMADI");
      } else {
        print("GEÇMİŞ MAÇLAR LİSTEYE ÇEKİLDİ");
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.fade,
            child: FirstOpeningPage(),
            duration: Duration(milliseconds: 1250),
          ),
        );
      }
    });
  }
}
