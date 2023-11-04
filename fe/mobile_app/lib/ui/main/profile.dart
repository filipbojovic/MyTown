import 'package:bot_fe/bottomNavBar.dart';
import 'package:bot_fe/components/Other/ConfirmDialog.dart';
import 'package:bot_fe/components/Other/RankListDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppUser.dart';
import 'package:bot_fe/models/DbModels/City.dart';
import 'package:bot_fe/services/api/city.api.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:bot_fe/ui/main/notification.dart';
import 'package:bot_fe/ui/profile/AcceptedChallengesScreen.dart';
import 'package:bot_fe/ui/profile/ChangePasswordScreen.dart';
import 'package:bot_fe/ui/profile/EditProfileScreen.dart';
import 'package:bot_fe/ui/profile/UserPostsScreen.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Profile extends StatefulWidget {
  final int userID;
  final bool myProfile;
  Profile(this.userID, this.myProfile);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  _ProfileState()
  {
    NotificationServices.selectedPage = 4;
    NotificationServices.notifController.pushToNotificationPage = _pushToNotifPage;
    NotificationServices.notifController.pushToLoginPage = _pushToLoginPage;
  }

  Future profileFuture;
  Future cityFuture;
  
  List<City> cities = new List<City>();
  AppUser userData;

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

  _getUserProfile(int id) async
  {
    return await UserAPIServices.getAppUserByID(id);
  }
  _getCities() async
  {
    return await CityAPIServices.getAllCities();
  }

  @override
  void initState() {
    super.initState();
    profileFuture = _getUserProfile(widget.userID); 
    cityFuture = _getCities();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        profileFuture,
        cityFuture
      ]),
      builder: (context, snapshot){
        if(snapshot.data == null)
          return BOTFunction.loadingIndicator();
        else
        {
          if(widget.myProfile)
            loggedUser = snapshot.data[0];
          userData = snapshot.data[0];
          cities = snapshot.data[1];
          return makeProfileView(context, snapshot.data[0]);
        }
      },
    );
  }

  Scaffold makeProfileView(BuildContext context, AppUser user) {
    return Scaffold(
      drawerScrimColor: Colors.black,
      endDrawer: endDrawer(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(47.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              widget.userID == loggedUser.id ? 'Moj profil' : "",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme:  IconThemeData(color: Colors.black),
          )),
      //backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  makeHeader(user, context),
                  SizedBox(height: 20.0),
                  makeMiddleInfo()
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(4),
    );
  }

  Container makeMiddleInfo() {
    TextStyle style = new TextStyle(
      color: Colors.black,
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontWeight: FontWeight.w500
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Podaci o korisniku"),
          ),
          //Divider(),
          ListTile(
            title: Text("E-mail", style: style),
            subtitle: Text(userData.email, style: TextStyle(color: Colors.black)),
            leading: Icon(Icons.email, color: Colors.green),
          ),
          ListTile(
            title: Text("Grad", style: style),
            subtitle: Text(userData.city, style: TextStyle(color: Colors.black)),
            leading: Icon(Icons.location_city, color: Colors.green),
          ),
          ListTile(
            title: Text("Član od", style: style),
            subtitle: Text(BOTFunction.formatDate(userData.joinDate), style: TextStyle(color: Colors.black)),
            leading: Icon(Icons.calendar_today, color: Colors.green),
          ),
          ListTile(
            title: Text("Datum rođenja", style: style),
            subtitle: Text(BOTFunction.formatBirthDate(userData.birthDate), style: TextStyle(color: Colors.black)),
            leading: Icon(Icons.cake, color: Colors.green),
          ),
          ListTile(
            title: Text("Pol", style: style),
            subtitle: Text(userData.genderID == GenderTypeEnum.male ? "Muški" : "Ženski", style: TextStyle(color: Colors.black)),
            leading: Icon(MaterialCommunityIcons.gender_male_female, color: Colors.green),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              makeMyPostsButton(),
              if(widget.userID == loggedUser.id) makeMyChallengesButton(),
            ],
          ),
        ],
      ),
    );
  }

  RaisedButton makeMyPostsButton() {
    return RaisedButton(
      color: Colors.green,
      autofocus: true,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserPostsScreen(widget.userID)));
      },
      child: Container(
        child: Text(
          widget.userID == loggedUser.id ? "Moje objave" : "Objave",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
    );
  }

  RaisedButton makeMyChallengesButton() {
    return RaisedButton(
      color: Colors.green,
      autofocus: true,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AcceptedChallengesScreen(widget.userID)));
      },
      child: Container(
        child: Text(
          "Prihvaćeni izazovi",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
    );
  }

  Widget makeHeader(AppUser user, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              makeProfilePhoto(user.profilePhotoURL),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
              Column(
                children: [
                  Text(user.firstName +" " +user.lastName, style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.045)),
                  makeRankView(user, context),
                ],
              ),
            ],
          ),
          SizedBox(height: 5.0),
          makeUnderProfilePhotoRow(user),
        ],
      ),
    );
  }

  Row makeRankView(AppUser user, BuildContext context) {
    return Row(
      children: [
        Text(user.rankName, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04)),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
          child: ClipRRect(
            child: Image.network(defaultServerURL +user.rankPhotoURL),
          ),
          width: MediaQuery.of(context).size.width * 0.08,
          height: MediaQuery.of(context).size.width * 0.08,
        )
      ],
    );
  }

  Row makeUnderProfilePhotoRow(AppUser user) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Text(user.ecoFPoints.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold),),
              Text("Društveni poeni", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),)
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(user.numOfPosts.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold),),
              Text("Broj objava", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),)
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(user.numOfSolvedChallenges.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold),),
              Text("Rešeni izazovi", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),)
            ],
          ),
        ),
      ],
    );
  }

  Widget makeProfilePhoto(String image) {
    return CircleAvatar(
      backgroundImage: NetworkImage(defaultServerURL +image),
      radius: MediaQuery.of(context).size.width * 0.13,
    );
  }

  //--------------------------------------SIDEMENU-----------------------------------------------------
  Drawer endDrawer() {
    return Drawer(
        child: Column(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            makeEditProfileButton(),
            makeChangePasswordButton(),
            makeTop10Button(),
            makeLogOutButton(),
          ],
        )
      ],
    ));
  }

  FlatButton makeLogOutButton() {
    return FlatButton(
      autofocus: true,
      onPressed: () async {
        await storage.delete(key: "jwt");

        NotificationServices.disposeNotifications();

        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Container(
          padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
          child: Row(
            children: <Widget>[
              Icon(MaterialCommunityIcons.logout, color: Colors.green),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(
                "Odjavi se",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              )
            ],
          ),
        ),
    );
  }

  FlatButton makeChangePasswordButton() {
    return FlatButton(
      autofocus: true,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
      },
      child: Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
        child: Row(
          children: <Widget>[
            Icon(Icons.lock_outline, color: Colors.green),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              "Promeni lozinku",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeTop10Button()
  {
    return FlatButton(
      autofocus: true,
      onPressed: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          child: RankListDialog()
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
        child: Row(
          children: <Widget>[
            Icon(Icons.grade, color: Colors.green),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              "Top 10 korisnika",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeEditProfileButton()
  {
    return FlatButton(
      autofocus: true,
      onPressed: () async {
        Navigator.pop(context);
        await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(loggedUser, cities)));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.04,
          bottom: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.settings, color: Colors.green),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              "Izmeni profil",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            )
          ],
        ),
      ),
    );
  }
}
