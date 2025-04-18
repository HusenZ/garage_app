import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garage_app/presentation/screens/garage_home_screen.dart';
import 'package:garage_app/presentation/screens/role_login.dart';
import 'package:garage_app/presentation/screens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      // Not logged in, go to login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RoleLogin()),
        (route) => false,
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User somehow not authenticated, force logout
      await prefs.setBool('isLoggedIn', false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RoleLogin()),
        (route) => false,
      );
      return;
    }

    final uid = user.uid;

    // 1. Try users collection
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final role = userDoc.data()?['role'];
      if (role == 'user') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
        return;
      }
    }

    // 2. Try garage collection
    final garageDoc =
        await FirebaseFirestore.instance.collection('garage').doc(uid).get();
    if (garageDoc.exists) {
      final role = garageDoc.data()?['role'];
      if (role == 'garage') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => GarageHomeScreen()),
          (route) => false,
        );
        return;
      }
    }

    // If no role found, reset everything and go to login
    await FirebaseAuth.instance.signOut();
    await prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => RoleLogin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.webp')),
    );
  }
}
