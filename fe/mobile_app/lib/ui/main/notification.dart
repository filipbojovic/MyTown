import 'dart:async';
import 'package:bot_fe/bottomNavBar.dart';
import 'package:bot_fe/components/Other/ConfirmDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppNotification.dart';
import 'package:bot_fe/services/api/notification.api.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:bot_fe/ui/sub_pages/PostAndCommentScreen.dart';
import 'package:flutter/material.dart';

class UserNotification extends StatefulWidget {
  //final SkeletonController controller;
  UserNotification();

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  
  _UserNotificationState()
  {
    NotificationServices.selectedPage = 3;
    NotificationServices.notifController.pushToNotificationPage = _pushToNotifPage;
    NotificationServices.notifController.addOneNotification = _addOneNotification;
    NotificationServices.notifController.pushToLoginPage = _pushToLoginPage;
  }

  StreamController _notificationStreamController;
  Stream _stream;
  List<AppNotification> _fullList = new List<AppNotification>();

  _pushToNotifPage()
  {
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => UserNotification()
    ));
  }

   _pushToLoginPage() async
  {
    await showDialog(
      context: context,
      barrierDismissible: false,
      child: ConfirmDialog("Vaš nalog je obrisan od strane administratora. Za više informacija pošaljite e-mail na mojgrad.srb.rs@gmail.com.")
    );
    storage.delete(key: "jwt");
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => Login()
    ));
  }

  _setUpStream()
  {
    _notificationStreamController = StreamController();
    _stream = _notificationStreamController.stream;
  }

  _getNotifications() async {
    await NotificationAPIService.getUserNotifications(int.parse(loggedUserID)).then((value) {
      _notificationStreamController.add(value);
      _fullList = value;
    });
  }

  _addOneNotification(AppNotification appN)
  {
    _fullList.insert(0, appN);
    _notificationStreamController.add(_fullList);
  }

  @override
  void initState() {
    super.initState();

    _setUpStream();
    _getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return BOTFunction.loadingIndicator();
          else
          {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                AppNotification notif = snapshot.data[index];
                return makeNotificationTile(notif, context);
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(3),
    );
  }

  Widget makeNotificationTile(AppNotification notif, BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PostAndCommentScreen(notif.postID)
          )
        );
      },
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(defaultServerURL +notif.userProfilePhoto)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notif.header, style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.0365),),
            SizedBox(height: 2.0,),
            Text(
              BOTFunction.getTimeDifference(notif.date),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.033,
                color: Colors.grey[600]
              )
            )
          ],
        )
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: null,
        child: Divider(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Obaveštenja',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
