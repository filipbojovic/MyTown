import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:web_app/components/Other/ChangeAdminPasswordDialog.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/services/storage.services.dart';
import 'package:web_app/ui/ADMINISTRATOR/pages/PostScreen.dart';
import 'package:web_app/ui/ADMINISTRATOR/pages/StatisticScreen.dart';
import 'package:web_app/ui/ADMINISTRATOR/pages/UserScreen.dart';
import 'package:web_app/ui/INSTITUTION/pages/InstitutionEditProfileScreen.dart';
import 'package:web_app/ui/INSTITUTION/pages/InstitutionPostScreen.dart';
import 'package:web_app/ui/LoginScreen.dart';
import 'ADMINISTRATOR/pages/RankScreen.dart';
import 'ADMINISTRATOR/pages/ReportScreen.dart';
import 'ADMINISTRATOR/pages/StatisticScreen.dart';

class HomeScreen extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;
  HomeScreen(this.jwt, this.payload);

  factory HomeScreen.fromBase64(String jwt) {
    return HomeScreen(
        jwt,
        jsonDecode(
            ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));
  }

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  TabController tabController;
  int active = 0;
  Future institutionFuture;

  @override
  void initState() {
   
    Storage.setUserID = widget.payload['nameid'];
    Storage.setName = widget.payload['sub'][0];
    Storage.setUserType = widget.payload['sub'][1];

    tabController = new TabController(vsync: this, length: Storage.getUserType == UserTypeEnum.administrator.toString() ? 5 : 2, initialIndex: Storage.getIndex != null ? int.parse(Storage.getIndex) : 0)//0)
      ..addListener(() {
        setState(() {
          active = tabController.index;
        });
      });
    if(Storage.getUserType == UserTypeEnum.institution.toString())
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: makeAppBar(context),
      ),
      backgroundColor: themeColor,
      body: Container(
        color: themeColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.white,
              ),
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.15,
              child: listDrawerItems(false)
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: themeColor,
              ),
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
              padding: EdgeInsets.only(top: 5.0),
              width: MediaQuery.of(context).size.width * 0.837,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  Storage.getUserType == UserTypeEnum.administrator.toString() ? PostScreen() : InstitutionPostScreen(),
                  if(Storage.getUserType == UserTypeEnum.administrator.toString()) UserScreen(),
                  if(Storage.getUserType == UserTypeEnum.administrator.toString()) StatisticScreen(),
                  if(Storage.getUserType == UserTypeEnum.administrator.toString()) Report(),
                  if(Storage.getUserType == UserTypeEnum.administrator.toString()) RankScreen(),
                  if(Storage.getUserType == UserTypeEnum.institution.toString()) InstitutionEditProfileScreen(), //here should be page for editing institution data
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container makeAppBar(BuildContext _context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Dobrodošli, ',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.012,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextSpan(
                  text: Storage.getName,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.013,
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ]
            ),
          ),
          Row(
            children: [
              if(loggedAdministrator != null)
                makeChangePasswordButton(_context),
              makeLogOutButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget listDrawerItems(bool drawerStatus) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        makeLogo(),
        makePostsButton(drawerStatus),
        if(Storage.getUserType == UserTypeEnum.administrator.toString()) makeUsersButton(drawerStatus),
        if(Storage.getUserType == UserTypeEnum.administrator.toString()) makeStatisticsButton(drawerStatus),
        if(Storage.getUserType == UserTypeEnum.administrator.toString()) makeReportButton(drawerStatus),
		    if(Storage.getUserType == UserTypeEnum.administrator.toString()) makeRanksButton(drawerStatus),
        if(Storage.getUserType == UserTypeEnum.institution.toString()) makeEditProfileButton(drawerStatus),
      ],
    );
  }
  
    Widget makeRanksButton(bool drawerStatus) {
  return FlatButton(
      color: tabController.index == 4 ? themeColor : Colors.white,
      onPressed: () {
        Storage.setIndex = 4.toString();
        tabController.animateTo(4);
      },
      child: Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
        child: Row(children: [
          Icon(OMIcons.stars),
          SizedBox(width: 8),
          Text(
            "Nivoi  ",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            ),
          ),
        ]),
      ),
    );
}  
  
Widget makeReportButton(bool drawerStatus) {
  return FlatButton(
    color: tabController.index == 3 ? themeColor : Colors.white,
    onPressed: () {
      Storage.setIndex = 3.toString();
      tabController.animateTo(3);
    },
    child: Container(
      padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
      child: Row(children: [
        Icon(OMIcons.speakerNotes),
        SizedBox(width: 8),
        Text(
          "Prijave",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
      ]),
    ),
  );
}

  Widget makeStatisticsButton(bool drawerStatus) {
    return FlatButton(
      color: tabController.index == 2 ? themeColor : Colors.white,
      onPressed: () {
        Storage.setIndex = 2.toString();
        tabController.animateTo(2);
      },
      child: Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
        child: Row(children: [
          Icon(OMIcons.insertChartOutlined),
          SizedBox(width: 8),
          Text(
            "Statistika",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            ),
          ),
        ]),
      ),
    );
  }



  Widget makeUsersButton(bool drawerStatus) {
    return FlatButton(
      color: tabController.index == 1 ? themeColor : Colors.white,
      onPressed: () {
        Storage.setIndex = 1.toString();
        tabController.animateTo(1);
      },
      child: Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
        child: Row(children: [
          Icon(Icons.exit_to_app),
          SizedBox(width: 8),
          Text(
            "Korisnici",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            ),
          ),
        ]),
      ),
    );
  }


Widget makePostsButton(bool drawerStatus) {
  return FlatButton(
      color: tabController.index == 0 ? themeColor : Colors.white,
      onPressed: () {
        Storage.setIndex = 0.toString();
        tabController.animateTo(0);
      },
      child: Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
        child: Row(children: [
          Icon(OMIcons.dashboard),
          SizedBox(width: 8),
          Text(
            "Objave",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            ),
          ),
        ]),
      ),
    );
}

  Container makeLogo() {
    return Container(
        margin: EdgeInsets.only(top: 5.0),
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: Image.asset(
          'assets/images/logo.png',
        ));
  }

  FlatButton makeEditProfileButton(bool drawerStatus) {
    return FlatButton(
      color: tabController.index == 1 ? Colors.grey[300] : Colors.white,
      onPressed: () {
        Storage.setIndex = 1.toString();
        tabController.animateTo(1);
      },
      child: Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
        child: Row(children: [
          Icon(Icons.exit_to_app),
          SizedBox(width: 8),
          Text(
            "Moj profil",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ]),
      ),
    );
  }

  Widget makeChangePasswordButton(BuildContext _context)
  {
    return IconButton(
      icon: Icon(MaterialCommunityIcons.account_settings),
      onPressed: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          child: ChangeAdminPasswordDialog(_context)
        );
      },
    );
  }

  IconButton makeLogOutButton() 
  {
    return IconButton(
      color: Colors.black,
      icon: Icon(Icons.exit_to_app),
      onPressed: () {
        loggedAdministrator = null;
        Storage.setToken = null;
        Storage.setUserType = null;
        Storage.setUserID = null;
        Storage.setName = null;
        Storage.setIndex = 0.toString();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
    );
  }
}
