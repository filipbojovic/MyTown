import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/services/api/administrator.api.dart';
import 'package:web_app/services/api/institution.api.dart';
import 'package:web_app/services/storage.services.dart';
import 'package:web_app/ui/HomeScreen.dart';
import 'package:web_app/ui/LoginScreen.dart';

import 'config/config.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  Future<String> get jwtOrEmpty async
  {
    var jwt = Storage.getToken;
    if(jwt == null)
      return "";

    var jwtParts = jwt.split(".");
    var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwtParts[1]))));
    String id = payload['nameid'];
    int typeID = int.parse(payload['sub'][1]);

    if(typeID == UserTypeEnum.administrator)
      loggedAdministrator = await AdministratorAPIServices.getAdministratorByID(id);
    else
      loggedUser = await InstitutionAPIServices.getAppInstitution(id);
    
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyan,
                strokeWidth: 5,
              ),
            );
          else if(snapshot.data != "") //already got token
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
                //Storage.setIndex = 0.toString();
                return HomeScreen(str, payload);
              }
              else
                return Login();
            }
          }
          else
          {
            return Login();
          }
        },
      ),
      theme: ThemeData(
          primaryColor: Colors.green[300]
        ),
      debugShowCheckedModeBanner: false,
      title: 'Moj grad',
    );
  }
}
