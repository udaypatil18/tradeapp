import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  // Private constructor
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Channel IDs
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'Channel for important notifications';

  // Initialize everything at once
  Future<void> initialize() async {
    if (_isInitialized) return; // Prevent multiple initializations

    await _createNotificationChannel();
    await _initializeLocalNotifications();
    await _setupFirebaseMessaging();

    _isInitialized = true;
    print("✅ NotificationService fully initialized");
  }

  // Create notification channel (required for Android 8.0+)
  Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      print("📢 Creating notification channel...");

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      print("✅ Notification channel created");
    }
  }

  // Get FCM Token
  Future<String?> getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print("🔹 FCM Token: $token"); // Debugging
      return token;
    } catch (e) {
      print("⚠️ Failed to get FCM token: $e");
      return null;
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    print("🔔 Initializing local notifications...");

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings - updated to work with newer versions
    final DarwinInitializationSettings iosSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine platform settings
    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🔔 Notification Clicked: ${response.payload}");
      },
    );

    print("✅ Local notifications initialized");
  }

  // Setup Firebase Messaging
  Future<void> _setupFirebaseMessaging() async {
    print("🔔 Setting up Firebase Messaging...");

    // Request permission on both platforms
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      print(
          "✅ User granted notification permission: ${settings.authorizationStatus}");

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Foreground Message Received: ${message.notification?.title}");

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If notification contains data and is an Android notification
        if (notification != null) {
          print("📱 Preparing to show foreground notification from Firebase");

          // Show notification
          showNotification(
            notification.title ?? "No Title",
            notification.body ?? "No Body",
          );
        }
      });

      // Handle app open from notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("🔔 Notification Clicked: ${message.notification?.title}");
      });

      // Check if app was opened from notification
      RemoteMessage? initialMessage =
          await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print("📩 Initial Notification: ${initialMessage.notification?.title}");
      }

      // Set foreground notification presentation options for iOS
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      print("✅ Firebase Messaging setup completed");
    } else {
      print("❌ User denied notification permission");
    }
  }

  // Show notification
  Future<void> showNotification(String title, String body,
      {String? payload}) async {
    print("📱 Showing notification: $title - $body");

    try {
      // Android notification details
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(body),
      );

      // iOS notification details
      DarwinNotificationDetails iOSPlatformChannelSpecifics =
          const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
      );

      // Combine platform details
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // Show the notification
      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformChannelSpecifics,
        payload: payload ?? 'notification_payload',
      );

      print("✅ Notification dispatched with ID: $notificationId");

      // Verify active notifications (Android only)
      if (Platform.isAndroid) {
        List<ActiveNotification>? activeNotifications =
            await _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.getActiveNotifications();

        print("🔍 Active notifications: ${activeNotifications?.length ?? 0}");
      }
    } catch (e) {
      print("❌ Error showing notification: $e");
    }
  }

  // Store processed notification IDs
  Future<void> _storeProcessedNotifications(List<int> notificationIds) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get existing processed notifications
      List<String> existingIds =
          prefs.getStringList('processed_notification_ids') ?? [];

      // Add new IDs to the list
      Set<String> uniqueIds = {...existingIds};
      for (var id in notificationIds) {
        uniqueIds.add(id.toString());
      }

      // Store the updated list
      await prefs.setStringList(
          'processed_notification_ids', uniqueIds.toList());

      // Keep only the last 1000 notification IDs to prevent the list from growing too large
      if (uniqueIds.length > 1000) {
        List<String> trimmedList = uniqueIds.toList();
        trimmedList.sort(
            (a, b) => int.parse(b).compareTo(int.parse(a))); // Sort descending
        trimmedList = trimmedList.sublist(0, 1000); // Take latest 1000
        await prefs.setStringList('processed_notification_ids', trimmedList);
      }

      print(
          "✅ Stored ${notificationIds.length} new notification IDs. Total tracked: ${uniqueIds.length}");
    } catch (e) {
      print("❌ Error storing processed notifications: $e");
    }
  }

  // Check if notification has been processed
  Future<bool> _hasNotificationBeenProcessed(int notificationId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> processedIds =
          prefs.getStringList('processed_notification_ids') ?? [];
      return processedIds.contains(notificationId.toString());
    } catch (e) {
      print("❌ Error checking processed notifications: $e");
      return false;
    }
  }

  // Fetch notifications from API
  Future<void> fetchNotifications() async {
    print("📡 Fetching notifications from API...");

    try {
      final response = await http.get(
        Uri.parse('Enter the api here'),
        headers: {
          'Cache-Control': 'no-cache',
          'Accept': 'application/json',
        },
      );

      print("🔍 API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          // Try to parse the response
          var jsonData;
          try {
            jsonData = jsonDecode(response.body);
            print("✅ JSON successfully parsed");
          } catch (e) {
            print("❌ JSON Parse Error: $e");
            return;
          }

          // Determine the structure of the response
          List<dynamic> notifications = [];
          if (jsonData is List) {
            print("📋 Response is a List with ${jsonData.length} items");
            notifications = jsonData;
          } else if (jsonData is Map) {
            print("📋 Response is a Map with keys: ${jsonData.keys.toList()}");
            // Check if there's a data array inside
            if (jsonData.containsKey('data') && jsonData['data'] is List) {
              notifications = jsonData['data'];
            } else if (jsonData.containsKey('notifications') &&
                jsonData['notifications'] is List) {
              notifications = jsonData['notifications'];
            } else {
              // Try using the entire object as a single notification
              notifications = [jsonData];
            }
          } else {
            print("❌ Unexpected response format: ${jsonData.runtimeType}");
            return;
          }

          print("✅ Found ${notifications.length} notifications to process");

          // Process each notification
          int countDisplayed = 0;
          List<int> processedIds = [];

          for (var notification in notifications) {
            print("🔍 Processing notification: $notification");

            // Extract ID flexibly
            int notificationId;
            if (notification.containsKey('id')) {
              notificationId = int.tryParse(notification['id'].toString()) ?? 0;
            } else if (notification.containsKey('notification_id')) {
              notificationId =
                  int.tryParse(notification['notification_id'].toString()) ?? 0;
            } else {
              // Generate a unique ID based on content hash if no ID exists
              String contentHash = _generateContentHash(notification);
              notificationId = contentHash.hashCode;
              print("⚠️ No ID found, generated hash ID: $notificationId");
            }

            // Check if this notification has already been processed
            bool alreadyProcessed =
                await _hasNotificationBeenProcessed(notificationId);
            if (alreadyProcessed) {
              print(
                  "⏭️ Skipping already processed notification ID: $notificationId");
              continue;
            }

            // Extract title and body flexibly
            String title = '';
            if (notification.containsKey('title')) {
              title = notification['title']?.toString() ?? '';
            } else if (notification.containsKey('notification_title')) {
              title = notification['notification_title']?.toString() ?? '';
            } else {
              title = "New Notification";
            }

            String body = '';
            if (notification.containsKey('post')) {
              body = notification['post']?.toString() ?? '';
            } else if (notification.containsKey('message')) {
              body = notification['message']?.toString() ?? '';
            } else if (notification.containsKey('body')) {
              body = notification['body']?.toString() ?? '';
            } else if (notification.containsKey('content')) {
              body = notification['content']?.toString() ?? '';
            } else {
              body = "Check app for details";
            }

            // Show the notification
            print("🆕 Showing new notification: $title");
            await showNotification(title, body);
            countDisplayed++;
            processedIds.add(notificationId);

            // Add a delay between notifications
            await Future.delayed(const Duration(milliseconds: 500));
          }

          // Store processed notification IDs
          if (processedIds.isNotEmpty) {
            await _storeProcessedNotifications(processedIds);
          }

          print("📊 Summary: Displayed $countDisplayed new notifications");

          if (countDisplayed == 0) {
            print("📭 No new notifications to display");
          }
        } catch (e) {
          print("❌ Error processing notifications: $e");
        }
      } else {
        print(
            "❌ Failed to fetch notifications. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Network error: $e");
    }
  }

  // Generate a content hash for a notification with no ID
  String _generateContentHash(dynamic notification) {
    // Create a string with key elements of the notification
    String content = "";

    if (notification.containsKey('title')) {
      content += notification['title']?.toString() ?? '';
    }

    if (notification.containsKey('post')) {
      content += notification['post']?.toString() ?? '';
    } else if (notification.containsKey('message')) {
      content += notification['message']?.toString() ?? '';
    } else if (notification.containsKey('body')) {
      content += notification['body']?.toString() ?? '';
    }

    if (notification.containsKey('created_at')) {
      content += notification['created_at']?.toString() ?? '';
    }

    // Return a simple hash (or use the content directly if it's short)
    return content.length > 20 ? content.substring(0, 20) : content;
  }

  // Start polling
  void startNotificationPolling() {
    // Start regular polling
    print("🔄 Fetching notifications immediately...");
    fetchNotifications(); // Fetch once immediately

    print("🔄 Starting notification polling (every 1 minute)");
    Timer.periodic(const Duration(minutes: 5), (timer) {
      print("⏰ Periodic check for notifications triggered");
      fetchNotifications();
    });
  }

  // Reset the stored notification tracking
  Future<void> resetProcessedNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('processed_notification_ids');
    await prefs.remove('last_notification_id'); // Clear legacy tracking too
    print("🔄 Reset notification tracking data");
  }
}

// Helper function for string length
int min(int a, int b) {
  return (a < b) ? a : b;
}
