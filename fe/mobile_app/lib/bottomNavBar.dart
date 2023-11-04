import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/ui/main/HomePageScreen.dart';
import 'package:bot_fe/ui/main/map.dart';
import 'package:bot_fe/ui/main/new_post.dart';
import 'package:bot_fe/ui/main/notification.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'ui/main/notification.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  BottomNavBar(this.selectedIndex);

  @override
  _BottomNavBarState createState() => _BottomNavBarState(selectedIndex);
}
  
class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  
  int _selectedIndex;
  _BottomNavBarState(this._selectedIndex)
  {
    NotificationServices.notifController.runAnimation = _runAnimation;
  }
  bool _unreadNotifications;
  AnimationController _animationController;

  _runAnimation() async
  {
    setState(() {
      _unreadNotifications = true;
    });
    for(int i=0; i<3; i++)
    {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  @override
  void initState() {
    
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _unreadNotifications = loggedUser.unreadNotification;
    super.initState();
  }

  _callBackFunction(int index)
  {
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomePage()
        ),
        (route) => false); break;
      case 1:
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => MyMap()
        ),
        (route) => false); break;
      case 2:
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => NewPost()
        ),
        (route) => false); break;
      case 3:
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => UserNotification()
        ),
        (route) => false); break;
      case 4:
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Profile(int.parse(loggedUserID), true)
        ),
        (route) => false); break;
      
      default: 
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomePage()
        ),
        (route) => false); break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return makeBottomBar();
  }

  Container makeBottomBar() {
    var bottomBarStyle = TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.0361,
      color: Colors.black
    );
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.2,
          )
        )
      ),
      child: BottomNavigationBar(
        elevation: 0.0,
        fixedColor: bottomBarFixedIconColor,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, //floating or not 
        items: [
          makeHomePageIcon(bottomBarStyle),
          makeMapIcon(bottomBarStyle),
          makeNewPostIcon(bottomBarStyle),
          makeNotificationIcon(bottomBarStyle),
          makeProfileIcon(bottomBarStyle)
        ],
        onTap: (index) { //every time we click on some item in bottomMENU

          if(index == 3)
            setState(() => loggedUser.setUnreadNotification = false);
          _callBackFunction(index);
        },
      ),
    );
  }

  BottomNavigationBarItem makeProfileIcon(TextStyle bottomBarStyle) {
    return BottomNavigationBarItem(
      icon: Icon(OMIcons.person, color: bottomBarIconColor),
      title: Text('Profil', style: bottomBarStyle),
      activeIcon: Icon(Icons.person)
    );
  }

  BottomNavigationBarItem makeNotificationIcon(TextStyle bottomBarStyle) {
    return BottomNavigationBarItem(
      icon: RotationTransition(
        turns: Tween(begin: 0.0, end: -.1)
              .chain(CurveTween(curve: Curves.elasticIn))
              .animate(_animationController),
        child: _unreadNotifications ? makeActiveNotificationIcon() : Icon(OMIcons.notifications, color: Colors.black,)
      ),
      title: Text('Obaveštenja', style: bottomBarStyle),
      activeIcon: Icon(Icons.notifications)
    );
  }

  BottomNavigationBarItem makeNewPostIcon(TextStyle bottomBarStyle) {
    return BottomNavigationBarItem(
      icon: Icon(MaterialCommunityIcons.plus_box_outline,
      color: bottomBarIconColor),
      title: Text('Nova objava', style: bottomBarStyle),
      activeIcon: Icon(MaterialCommunityIcons.plus_box)
    );
  }

  BottomNavigationBarItem makeMapIcon(TextStyle bottomBarStyle) {
    return BottomNavigationBarItem(
      icon: Icon(MaterialCommunityIcons.map_search_outline, color: bottomBarIconColor,),
      title: Text('Mapa', style: bottomBarStyle),
      activeIcon: Icon(MaterialCommunityIcons.map_search)
    );
  }

  BottomNavigationBarItem makeHomePageIcon(TextStyle bottomBarStyle) {
    return BottomNavigationBarItem(
      icon: Icon(OMIcons.home, color: bottomBarIconColor),
      title: Text('Naslovna', style: bottomBarStyle),
      activeIcon: Icon(Icons.home)
    );
  }

  Widget makeActiveNotificationIcon()
  {
    return Stack(
      children: [
        Icon(OMIcons.notifications, color: Colors.black,),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.008,
          right: MediaQuery.of(context).size.width * 0.005,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(7.0),
            ),
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.025,
              minHeight: MediaQuery.of(context).size.width * 0.025,
            ),
          ),
        )
      ],
    );
  }
}