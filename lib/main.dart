import 'dart:ui';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_update/in_app_update.dart';
import 'Authentication/SplashScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'notification.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
/*
Future<void> backgroundHandler(RemoteMessage message) async {
  print("📩 Background Message: ${message.notification?.title}");

  // Initialize Firebase for background handling if needed
  await Firebase.initializeApp();

  // Show notification even in background
  if (message.notification != null) {
    await NotificationService.instance.showNotification(
      message.notification!.title ?? "New Message",
      message.notification!.body ?? "You have a new notification",
    );
  }
}

/// Get Device ID
Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("📱 Android Device ID: ${androidInfo.id}"); // Debugging
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print("🍏 iOS Device ID: ${iosInfo.identifierForVendor}"); // Debugging
      return iosInfo.identifierForVendor;
    }
  } catch (e) {
    print("⚠️ Error retrieving device ID: $e");
  }
  return null;
}

/// Send Data to API
Future<void> sendDeviceInfoToAPI() async {
  print("📤 Preparing to send device info to API...");

  String? deviceId = await getDeviceId();
  String? fcmToken = await NotificationService.instance.getFCMToken();

  if (deviceId != null && fcmToken != null) {
    // Check if we've already sent this exact combination before
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String storageKey = 'last_sent_fcm_token_$deviceId';
    final String? lastSentToken = prefs.getString(storageKey);

    // Only send if token is new or has changed
    if (lastSentToken != fcmToken) {
      var url = Uri.parse("enter device token api insertion here");

      var bodyData = jsonEncode({
        "device_id": deviceId,
        "fcm_token": fcmToken,
      });

      print("🔍 API Request Body: $bodyData");

      try {
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: bodyData,
        );

        print("📨 Sending request to API...");

        if (response.statusCode == 201) {
          print("✅ Device Info Sent Successfully! Response: ${response.body}");

          // Save the token we just sent to avoid duplicates in future
          await prefs.setString(storageKey, fcmToken);

          // Also store timestamp of last successful registration
          await prefs.setInt(
              'last_fcm_registration', DateTime.now().millisecondsSinceEpoch);
        } else {
          print("❌ Failed to send device info. Status: ${response.statusCode}");
          print("⚠️ Response: ${response.body}");
        }
      } catch (e) {
        print("⚠️ API Request Error: $e");
      }
    } else {
      print(
          "🔄 Same FCM token already sent for this device. Skipping API call.");
    }git branch -M main
  } else {
    print("⚠️ Failed to retrieve Device ID or FCM Token");
  }
}

Future<void> checkAndUpdateFCMToken() async {
  String? deviceId = await getDeviceId();
  String? currentFcmToken = await NotificationService.instance.getFCMToken();

  if (deviceId != null && currentFcmToken != null) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String storageKey = 'last_sent_fcm_token_$deviceId';
    final String? lastSentToken = prefs.getString(storageKey);

    // Check if token has changed or if we haven't sent it before
    if (lastSentToken != currentFcmToken) {
      await sendDeviceInfoToAPI();
    }

    // Check if it's been more than 7 days since last registration
    final int lastRegistration = prefs.getInt('last_fcm_registration') ?? 0;
    final int daysSinceRegistration = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastRegistration))
        .inDays;

    // Refresh registration periodically even if token hasn't changed
    if (daysSinceRegistration > 7) {
      await sendDeviceInfoToAPI();
    }
  }
}
*/

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //print("🔥 Initializing Firebase...");
  //await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  //checkAndUpdateFCMToken();

  // Initialize Firebase Crashlytics
  //FlutterError.onError = (errorDetails) {    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  //};

  //PlatformDispatcher.instance.onError = (error, stack) {
  //  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //  return true;
  //};

  //print("🔔 Initializing notification service...");
  //await NotificationService.instance.initialize();
  //print("🔄 Starting notification polling...");
  //NotificationService.instance.startNotificationPolling();

  // Send device info to API
  //print("📱 Sending device info to API...");
  //await sendDeviceInfoToAPI();

  // Check for app update
  //await MyApp._checkForAppUpdate();

  // Run the app
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

  /// Check if an app update is available and trigger the update dialog
  static Future<void> _checkForAppUpdate() async {
    try {
      // Check for an update availability
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      // If an update is available, start the update process
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // If an immediate update is available, trigger it
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      print("Error checking for app update: $e");
    }
  }
}
