// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';

Future <void>handleBackgroundMessage(RemoteMessage message) async{
  print('Title:${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}
class FirebaseApi{

  final _firebaseMessaging= FirebaseMessaging.instance;
    Future<void> initNotifications() async {
      await _firebaseMessaging.requestPermission();
      final fCMToken= await _firebaseMessaging.getToken();
      print('token: $fCMToken');
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    }
}