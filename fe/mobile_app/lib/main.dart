import 'dart:convert';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:bot_fe/ui/main/HomePageScreen.dart';
import 'package:bot_fe/ui/main/map.dart';
import 'package:bot_fe/ui/main/new_post.dart';
import 'package:bot_fe/ui/main/notification.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:bot_fe/ui/sub_pages/LoadingScreen.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'config/config.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<String> get jwtOrEmpty async
  {
    var jwt = await storage.read(key: "jwt");

    if(jwt == null)
      return "";

    var jwtParts = jwt.split(".");
    var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwtParts[1]))));

    int userID = int.parse(payload['nameid']);
    var res = await UserAPIServices.userExistance(userID);
    if(res == "false")
    {
      await storage.delete(key: "jwt");
      return "";
    }


    loggedUser = await UserAPIServices.getAppUserByID(int.parse(payload['nameid']));
    loggedUserID = payload['nameid'];

    NotificationServices.setUpNotifications();
    
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moj grad',
      routes: {
        '/notification': (_) => UserNotification(),
        '/homepage': (_) => HomePage(),
        '/map': (_) => MyMap(),
        '/newpost': (_) => NewPost(),
        '/profile': (_) => Profile(int.parse(loggedUserID), true)
      },
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return LoadingScreen();
          if(snapshot.data != "")
          {
            var str = snapshot.data;
            var jwt = str.split(".");
            if(jwt.length != 3)
              return Login();
            else
            {
              var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
              if(DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000).isAfter(DateTime.now()))
              {
                return HomePage();
              }
              else
                return Login(); 
            }
          }
          else
            return Login();
        },
      )
    );
  }
}