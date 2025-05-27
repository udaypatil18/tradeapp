import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../MainScreen/DashboardScreen.dart';
import 'RegistrationScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Start splash sequence
    _startSplashSequence();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Bounce animation
    _bounceAnimation = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Show animation for 3 seconds

    // Check login status
    _checkLoginStatus();
  }

  Future<void> _storeFcmToken() async {
    try {
      // Get the FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        print("Unable to fetch FCM token.");
        return;
      }

      // Get UUID from SharedPreferences or generate a new one if it doesn't exist
      final prefs = await SharedPreferences.getInstance();
      String? storedUuid = prefs.getString('deviceUuid');

      if (storedUuid == null) {
        var uuid = Uuid();
        storedUuid = uuid.v4(); // Generate a random UUID
        await prefs.setString(
            'deviceUuid', storedUuid); // Store UUID in SharedPreferences
      }

      // Check if the UUID exists in Firestore, if not, create a new entry
      final docSnapshot = await FirebaseFirestore.instance
          .collection('fcmtoken')
          .doc(storedUuid)
          .get();

      if (docSnapshot.exists) {
        // UUID exists, check if the token is the same
        String? storedToken = docSnapshot['token'];
        if (storedToken != fcmToken) {
          // Token mismatch, override the old token
          await FirebaseFirestore.instance
              .collection('fcmtoken')
              .doc(storedUuid)
              .set({
            'token': fcmToken,
          });
          print("FCM token overridden in Firestore.");
        }
      } else {
        // UUID doesn't exist, create a new document with the token
        await FirebaseFirestore.instance
            .collection('fcmtoken')
            .doc(storedUuid)
            .set({
          'token': fcmToken,
        });
        print("FCM token stored in Firestore for new UUID.");
      }

      // Update SharedPreferences with the generated UUID
      await prefs.setString('deviceUuid', storedUuid);
      print("FCM token stored successfully with UUID $storedUuid.");
    } catch (e) {
      print("Error storing FCM token: $e");
    }
  }

  // Check login status
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String? username = prefs.getString('username');
    final String? mobile = prefs.getString('mobile');

    if (isLoggedIn && username != null && mobile != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RegistrationScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Image.asset(
                'assets/Splashlogo_twe.jpeg', // Replace with your image path
                width: 150,
                height: 150,
              ),
            );
          },
        ),
      ),
    );
  }
}
