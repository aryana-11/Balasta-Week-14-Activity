import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Function(String)? onTokenRefresh;

  Function(RemoteMessage)? onMessageReceived;

  Future<void> initialize() async {
    await _requestPermission();

    await _initializeLocalNotifications();
    await _createNotificationChannel();

    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    _setupMessageHandlers();

    await _getFCMToken();

    debugPrint('✅ NotificationService initialized successfully');
  }

  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('🔔 Notification permission status: ${settings.authorizationStatus}');
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('⚠️ Notification permission not granted');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('📱 Notification tapped: ${response.payload}');
      },
    );

    debugPrint('✅ Local notifications initialized');
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'push_notification_lab_channel',
      'Push Notification Lab',
      description: 'Channel for push notification lab with high priority',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    debugPrint('✅ High-priority notification channel created');
  }

  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📨 Foreground message received');
      debugPrint('  Title: ${message.notification?.title}');
      debugPrint('  Body: ${message.notification?.body}');
      debugPrint('  Data: ${message.data}');
      
      if (onMessageReceived != null) {
        onMessageReceived!(message);
      }
      
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📱 Background message opened');
      debugPrint('  Title: ${message.notification?.title}');
      debugPrint('  Body: ${message.notification?.body}');
      debugPrint('  Data: ${message.data}');
      
      if (onMessageReceived != null) {
        onMessageReceived!(message);
      }
      
      _handleMessage(message);
    });

    _firebaseMessaging.onTokenRefresh.listen((String newToken) {
      debugPrint('🔄 FCM Token refreshed');
      debugPrint('  New token: $newToken');
      
      _fcmToken = newToken;
      
      if (onTokenRefresh != null) {
        onTokenRefresh!(newToken);
      }
    });

    debugPrint('✅ Message handlers set up');
  }

  Future<void> _getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      
      if (token != null) {
        _fcmToken = token;
        debugPrint('📱 FCM Token obtained');
        debugPrint('  Token: $token');
      } else {
        debugPrint('⚠️ Failed to get FCM token');
      }
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'push_notification_lab_channel',
        'Push Notification Lab',
        channelDescription: 'Channel for push notification lab',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      DarwinNotificationDetails iosPlatformChannelSpecifics =
          const DarwinNotificationDetails();

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _localNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? 'No message body',
        platformChannelSpecifics,
        payload: message.data.toString(),
      );

      debugPrint('✅ Local notification shown');
    } catch (e) {
      debugPrint('❌ Error showing local notification: $e');
    }
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('📨 Handling message');
    debugPrint('  Title: ${message.notification?.title}');
    debugPrint('  Body: ${message.notification?.body}');
    debugPrint('  Data: ${message.data}');
  }
}
