import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Tiles/TilePostComponent.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/models/AppModels/AppUser.dart';
import 'package:web_app/services/api/post.api.dart';
import 'package:web_app/services/api/user.api.dart';
import 'package:web_app/ui/ADMINISTRATOR/pages/UserScreen.dart';
import 'package:web_socket_channel/html.dart';

class UserView extends StatefulWidget {

  final UserFilter filterController;
  UserView(this.filterController);

  @override
  _UserView createState() => _UserView();
}
//------------------------------UserView - FIRST SCREEN WHERE ARE ALL USERS
//------------------------------UserDetailScreen - SECOND SCREEN WITH DETAILS FOR USER

class _UserView extends State<UserView> 
{
  StreamController _userStreamController;
  StreamController _postStreamController;
  List<AppUser> _fullUserList;
  List<AppPost> _userPostsList;
  HtmlWebSocketChannel channel;

  TextEditingController searchController = new TextEditingController();
  
  AppUser userToShow;

  bool _showInfoUser = false;
  AppUser _userInfoDetailScreen;

  _loadUsers() async
  {
    await UserAPIServices.getFilteredUsers("", -1).then((value) {
      if(_userStreamController.isClosed)
        return;
      _userStreamController.add(value);
      _fullUserList = value;
    });
  }

  _removeUser(AppUser user)
  {
    _fullUserList.remove(user);
    _userStreamController.add(_fullUserList);
  }

  _filterUsers(String filterText, int cityID) async
  {
    await UserAPIServices.getFilteredUsers(filterText, cityID).then((value) {
      _userStreamController.add(value);
      _fullUserList = value;
    });
  }

  _getPostForUser(int userID) async 
  {
    await PostAPIServices.getAppPostsByUserID(userID).then((value){
      _postStreamController.add(value);
      _userPostsList = value;
    });
  }

  _removePostFromUserList(AppPost post)
  {
    _userPostsList.remove(post);
    _postStreamController.add(_userPostsList);
  }

  @override
  void initState() 
  {
    _userStreamController = new StreamController();
    _postStreamController = new StreamController.broadcast();
    widget.filterController.filterUsers = _filterUsers;
    _loadUsers();
    channel = HtmlWebSocketChannel.connect(imiSocket +loggedAdministrator.id.toString());

    super.initState();
  }

  @override
  void dispose() {
    _userStreamController.close();
    _postStreamController.close();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userStreamController.stream,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return BOTFunction.loadingIndicator();
        else
          return !_showInfoUser ? makeUserScreen(snapshot.data) : makeUserDetailScreen();
      },
    );
  }

  Widget makeUserScreen(List<AppUser> users) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      child: GridView.count(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        crossAxisCount: 5,
        mainAxisSpacing: MediaQuery.of(context).size.height * 0.003,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.002,
        childAspectRatio: MediaQuery.of(context).size.width * 0.30 / MediaQuery.of(context).size.height * 6.2,
        children: List.generate(
          users.length,
          (index) {
            return makeUserComponent(users[index]);
          }
        )
      )
    );
  }

  Widget makeUserComponent(AppUser user) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: themeColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          makeUserProfilePhoto(user.profilePhotoURL),
          makeInfoUserView(user),
          makeButtonsUserView(user),
        ],
      ),
    );
  }

  Container makeUserProfilePhoto(String profilePicturePath) {
    return Container(
      child: CircleAvatar(
        backgroundImage: NetworkImage(defaultServerURL + profilePicturePath),
        radius: MediaQuery.of(context).size.width * 0.016,
      ),
    );
  }

  Container makeInfoUserView(AppUser user) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(
            user.fullName,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.013,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Član od:',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.009,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            BOTFunction.formatDate(user.joinDate),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.009,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ]
      )
    );
  }

  Container makeButtonsUserView(AppUser user) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround, 
        children: [
          makeInfoButtonUserView(user), //button on userTILE
          makeDeleteButtonUserView(user),
        ]
      )
    );
  }

  Material makeInfoButtonUserView(AppUser user) 
  {
    return Material(
      color: themeColor,
      child: InkWell(
        child: Icon(
          Icons.info_outline,
          size: MediaQuery.of(context).size.width * 0.016
        ),
        onTap: () async 
        {
          setState(() {
            _userInfoDetailScreen = user;
            _showInfoUser = true;
          });
          _getPostForUser(user.id);
        },
      )
    );
  }

  Widget makeDeleteButtonUserView(AppUser user)
  {
    return Material(
      color: themeColor,
      child: InkWell(
        child: Icon(
          MaterialCommunityIcons.trash_can_outline,
          size: MediaQuery.of(context).size.width * 0.016
        ),
        onTap: () async 
        {
          var res = await showDialog(
            context: context,
            child: DeleteAlertDialog('Da li ste sigurni da želite da obrišete datog korisnika?'),
          );
          if(res)
            {
              _showDeleteDialog();
              await UserAPIServices.deleteUserEntity(user.id).then((value){
                Navigator.pop(context);
                _removeUser(user);
              });

              var data = new Map<String, dynamic>();
              data["receiverID"] = user.id;
              channel.sink.add(jsonEncode(data));
          }
        }
      ),
    );
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------------------------------------------------------
  //---------------------------------------------------------DETAIL SCREEN---------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------------------------------------------------------

  Widget makeUserDetailScreen() 
  {
    return StreamBuilder(
      stream: _postStreamController.stream,
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          return BOTFunction.loadingIndicator();
        else
        {
          return Expanded(
            child: Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      makeUserInfoDetailScreen(_userInfoDetailScreen),
                      makeButtonsDetailScreen(),
                    ]
                  ),
                  Expanded(child: makeUserPostsDetailScreen(snapshot.data)),
                ]
              )
            ),
          );
        }
      }
    );
  }

  Widget makeUserInfoDetailScreen(AppUser userInfo) { //left side
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      width: MediaQuery.of(context).size.width * 0.32,
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.grey[400])),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              makeProfilePhotoDetailScreen(userInfo),
              makeFieldsDetailScreen(userInfo)
            ],
          ),
        ],
      ),
    );
  }

  Widget makeUserPostsDetailScreen(List<AppPost> postsList) { //right side
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.grey[400])),
      height: MediaQuery.of(context).size.height,
      child: postsList.length > 0 ? GridView.count(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: MediaQuery.of(context).size.height * 0.003,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.002,
        childAspectRatio: MediaQuery.of(context).size.width * 0.37 / MediaQuery.of(context).size.height * 7.0,
        children: List.generate(
          postsList.length,
          (index) {
            return TilePostComponent(context, postsList[index], _removePostFromUserList);
          }
        ),
      ) : Center(
        child: Text("Korisnik nema objave")
      )
    );
  }

  Widget makeButtonsDetailScreen() 
  {
    return Container(
        width: MediaQuery.of(context).size.width * 0.32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            makeGoBackButton(),
            makeDeleteButton(),
        ],
      )
    );
  }
  
  Widget makeDeleteButton()
  {
    return FlatButton(
      color: Colors.grey[300],
      child: Text('Obriši korisnika'),
      onPressed: () async 
      {
        var res = await showDialog(
          context: context,
          child: DeleteAlertDialog('Da li ste sigurni da želite da obrišete datog korisnika?'),
        );

        if(res)
        {
          _showDeleteDialog();
          await UserAPIServices.deleteUserEntity(_userInfoDetailScreen.id).then((value){
            Navigator.pop(context);
            _removeUser(_userInfoDetailScreen);

            setState(() {
              userToShow = null;
              _showInfoUser = false;
            });

            var data = new Map<String, dynamic>();
            data["receiverID"] = _userInfoDetailScreen.id;
            channel.sink.add(jsonEncode(data));
          });
        }
      }
    );
  }

  _showDeleteDialog()
  {
    showDialog(
      context: context,
      child: LoadingDialog("Brisanje korisnika u toku...")
    );
  }

  FlatButton makeGoBackButton() {
    return FlatButton(
        color: Colors.grey[300],
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.chevron_left,
                  size: MediaQuery.of(context).size.width * 0.02),
              Text('Nazad')
            ]),
        onPressed: () {
          setState(() {
            _showInfoUser = false;
          }
        );
      },
    );
  }

  Container makeFieldsDetailScreen(AppUser userInfo) 
  {
    double fontSize = MediaQuery.of(context).size.width * 0.01;
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          makeUserNameField(fontSize, userInfo.fullName),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          makeCityField(fontSize, userInfo.city),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          makeEmailField(fontSize, userInfo.email),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          makeSocialPoints(fontSize, userInfo.ecoFPoints),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          makeRankField(fontSize, userInfo.rankName, userInfo.rankPhotoURL),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          makeJoinDateField(fontSize, userInfo.joinDate)
        ],
      ),
    );
  }

  Widget makeUserNameField(double fontSize, String fullName)
  {
    return  RichText(
      text: TextSpan(
       children: [
          TextSpan(
            text: 'Ime i prezime: ',
            style: TextStyle(color: Colors.black, fontSize: fontSize)
          ),
          TextSpan(
            text: fullName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize)
          )
        ]
      ),
    );
  }

  Widget makeCityField(double fontSize, String city)
  {
    return RichText(
      text: TextSpan(
        children: [
            TextSpan(
              text: 'Grad: ',
              style: TextStyle(color: Colors.black, fontSize: fontSize)
            ),
            TextSpan(
              text: city,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: fontSize)
            )
          ]
        ),
      );
  }

  Widget makeEmailField(double fontSize, String email)
  {
    return  RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'e-mail: ',
            style: TextStyle(color: Colors.black, fontSize: fontSize)
          ),
          TextSpan(
            text: email,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize
            )
          )
        ]
      ),
    );
  }

  Widget makeSocialPoints(double fontSize, int ecoFPoints)
  {
    return RichText(
      text: TextSpan(
        children: [
            TextSpan(
                text: 'Društveni poeni: ',
                style: TextStyle(color: Colors.black, fontSize: fontSize)
            ),
            TextSpan(
              text: ecoFPoints.toString(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: fontSize
            )
          )
        ]
      ),
    );
  }

  Widget makeRankField(double fontSize, String rankName, String rankImage)
  {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Rank: ',
            style: TextStyle(color: Colors.black, fontSize: fontSize)
          ),
          TextSpan(
            text: rankName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize
            )
          )
        ]
      ),
    );
  }

  Widget makeJoinDateField(double fontSize, DateTime joinDate)
  {
    return RichText(
      text: TextSpan(children: [
          TextSpan(
            text: 'Član od: ',
            style: TextStyle(color: Colors.black, fontSize: fontSize)
          ),
          TextSpan(
            text: BOTFunction.formatDate(joinDate),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize
            )
          )
        ]
      ),
    );
  }

  Container makeProfilePhotoDetailScreen(AppUser userInfo) 
  {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: CircleAvatar(
        backgroundImage:
            NetworkImage(defaultServerURL + userInfo.profilePhotoURL),
        radius: MediaQuery.of(context).size.width * 0.07,
      ),
    );
  }
}
