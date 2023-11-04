import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:frontend/common/platform/api_connectivity.dart';

class FCMService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static String get tokenValue => token ?? '';
  static Stream<String> get messagesStream => _messageStream.stream;

  // Se ejecuta cuando la app está en segundo plano
  static Future _backgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');

    _messageStream.add(message.data['title'] ?? 'No data');
  }

  // Se ejecuta cuando la app está en primer plano
  static Future _onMessageHandler(RemoteMessage message) async {
    // print('onMessage Handler ${message.messageId}');

    _messageStream.add(message.data['title'] ?? 'No data');
  }

  // Se ejecuta cuando la app está cerrada completamente y se abre desde la notificación
  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print('onMessageOpenApp Handler ${message.messageId}');

    _messageStream.add(message.data['title'] ?? 'No data');
  }

  Future<dynamic> sendNotification(Map<String, dynamic> payload) async {
    const endpoint = '/notification/send';
    final headers = {'Content-Type': 'application/json'};

    return await ApiConnectivity.post(endpoint, headers, payload);
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await messaging.getToken();

    if (kDebugMode) {
      print(token);
    }

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
