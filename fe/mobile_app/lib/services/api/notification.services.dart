import 'dart:convert';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

class NotificationServices
{
  static IOWebSocketChannel channel;
  static NotificationController notifController;
  static int selectedPage; //index of current page

  static final notifications = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;

  static setUpLocalNotifications()
  {
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings();
    notifications.initialize(InitializationSettings(settingsAndroid, settingsIOS), onSelectNotification: onSelectNotification);
  }

  static Future<Null> onSelectNotification(String payload) async
  {
      notifController.pushToNotificationPage();
      return null;
  }

  static showNotification(Map<String, dynamic> data) async
  {
     await _demoNotification(data);
  }

  static Future<void> _demoNotification(Map<String, dynamic> data) async
  {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID', 'channel_name', 'channel_description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      ticker: 'test ticker'
    );
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSChannelSpecifics);

    if(data['PostID'] == null)
    {
      notifController.pushToLoginPage();
    }
    else
    {
      int notifType = data['NotificationType'];
      if(notifType != NotificationTypeEnum.commentLike &&  notifType != NotificationTypeEnum.postLike)
        notifications.show(0, 'Novo obaveštenje', data['Header'], platformChannelSpecifics);

      if(selectedPage == 3)
        notifController.addOneNotification(
          AppNotification(data['Header'], data['UserProfilePhoto']['Path'], null, DateTime.parse(data['Date']), data['PostID'], data['NotificationType'])
        );

      loggedUser.setUnreadNotification = true;
      notifController.runAnimation();
    }
  }

  static setUpSocket()
  {
    channel = IOWebSocketChannel.connect(imiSocket +loggedUserID.toString());
    channel.stream.listen((val) {
      var mapData = jsonDecode(val);
      
      showNotification(mapData);
     });
  }

  static setUpNotifications()
  {
    setUpLocalNotifications();
    setUpSocket();
    notifController = new NotificationController();
  }

  static disposeNotifications()
  {
    channel.sink.close();
    notifController = null;
  }
}

class NotificationController
{
  void Function(AppNotification appN) addOneNotification;
  void Function() runAnimation;
  void Function() pushToNotificationPage;
  void Function() pushToLoginPage;
}