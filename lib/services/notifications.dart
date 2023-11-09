import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    AndroidInitializationSettings initializationSettingsAndroid= const AndroidInitializationSettings('coco');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );
    

    await notificationsPlugin.initialize(initializationSettings, onDidReceiveBackgroundNotificationResponse: 
    (NotificationResponse notificationResponse) async{});
    
  }
  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName', 
      importance: Importance.max)
    );
  }

  Future showNotification(
    {int id=0, String? title, String? body, String? payload}
  ) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }
  
  

   

}