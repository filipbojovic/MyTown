import 'dart:convert';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/AppModels/AppNotification.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:http/http.dart';

class NotificationAPIService {

  static Future getUserNotifications(int userEntityID) async 
  {
    var jwt = await storage.read(key: "jwt");
    var res = await get(serverURL +defaultNotificationURL +userEntityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    List<AppNotification> notifications = new List<AppNotification>();

    if(res.statusCode != 200)
      return null;
    if (res.statusCode == 200) 
      for (var item in jsonDecode(res.body))
        notifications.add(AppNotification.fromObject(item));
        
    return notifications;
  }
}
