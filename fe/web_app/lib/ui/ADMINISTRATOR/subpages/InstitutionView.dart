import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:web_app/components/Other/CreateNewInstitution.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Tiles/TilePostComponent.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppInstitution.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/services/api/institution.api.dart';
import 'package:web_app/services/api/post.api.dart';
import 'package:web_app/services/api/user.api.dart';
import 'package:web_app/ui/ADMINISTRATOR/pages/UserScreen.dart';

class InstitutionView extends StatefulWidget {

  final UserFilter filterController;
  InstitutionView(this.filterController);
  
  @override
  _InstitutionViewState createState() => _InstitutionViewState();
}

class _InstitutionViewState extends State<InstitutionView> {

  var scrollCon = new ScrollController();
  
  StreamController _streamCon;
  StreamController _postStreamController;
  List<AppInstitution> list = new List<AppInstitution>();
  List<AppPost> _userPostsList;
  
  bool _showInfoUser = false;
  AppInstitution userInfo;
  int userID;
  
  _getInstitutions() async 
  {
    await InstitutionAPIServices.getFilteredInstitutions("", -1).then((value){
      _streamCon.add(value);
      list = value;
    });
  }

  _filterUsers(String filterText, int cityID) async
  {
    await InstitutionAPIServices.getFilteredInstitutions(filterText, cityID).then((value){
      _streamCon.add(value);
      list = value;
    });
  }

  _addItemToList(AppInstitution data)
  {
    list.add(data);
    _streamCon.add(list);
  }

  _removeInstitution(AppInstitution user)
  {
    list.remove(user);
    _streamCon.add(list);
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
    _streamCon = new StreamController();
    _postStreamController = new StreamController.broadcast();
    widget.filterController.filterInstitutions = _filterUsers;
    _getInstitutions();
    super.initState();
  }

  @override
  void dispose() 
  {
    _streamCon.close();
    _postStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamCon.stream,
      builder: (context, snapshots) {
        if (!snapshots.hasData)
          return Container();
        else 
          return !_showInfoUser ? makeMainPageView(snapshots.data, context) : makeInstitutionDetailScreen();
      },
    );
  }

  //first page
  Widget makeMainPageView(List<AppInstitution> institution, BuildContext context){
    return Expanded(
      child: Stack(children: [
        makeInstitutionScreen(institution),
        makeFloatingButtonForAddingInstitution(context)
      ]),
    );
  }

  Widget makeInstitutionScreen(List<AppInstitution> institutions) {
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
          institutions.length,
          (index) {
            return makeInstitutionComponent(institutions[index]);
          }
        ),
      )
    );
  }

  //one institution
  Widget makeInstitutionComponent(AppInstitution institution) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: themeColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          makeInstitutionProfilePhoto(institution.imageURL),
          makeInfoInstitutionView(institution),
          makeButtonsInstitutionView(institution),
        ],
      ),
    );
  }

  //make profile picture
  Widget makeInstitutionProfilePhoto(String profilePicturePath) {
    return Container(
      child: CircleAvatar(
        backgroundImage: NetworkImage(defaultServerURL + profilePicturePath),
        radius: MediaQuery.of(context).size.width * 0.016,
      ),
    );
  }
  //make information field
  Widget makeInfoInstitutionView(AppInstitution user) {
    return Container(
      height:  MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          makeInstitutionName(user.name),
          Align(
            alignment: Alignment.bottomLeft,
            child: makeInstitutionHeadQuarders(user.headquaterName)
          ),
        ]
      )
    );
  }

  Widget makeInstitutionName(String name){
    return Text(
      name,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.010,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget makeInstitutionHeadQuarders(String location) {
    return Row(
      children: [
        Icon(OMIcons.business, size: MediaQuery.of(context).size.width * 0.012),
        Text(location,
          style: TextStyle(
            color: Colors.black87,
            fontSize: MediaQuery.of(context).size.width * 0.010,
            fontWeight: FontWeight.w400
          )
        ),
      ],
    );
  }

  Widget makeButtonsInstitutionView(AppInstitution institution)
  {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround, 
        children: [
          makeInfoButtonInstitutionView(institution),
          makeDeleteButtonInstitutionView(institution)
        ]
      )
    );
  }

  Widget makeInfoButtonInstitutionView(AppInstitution institution)
  {
    return Material(
      color: themeColor,
      child: InkWell(
          child: Icon(Icons.info_outline,
          size: MediaQuery.of(context).size.width * 0.016),
          onTap: () 
          {
             setState(() {
              userInfo = institution;
              _showInfoUser = true;
            });
            _getPostForUser(institution.id);
        },
      )
    );
  } 

  Widget makeDeleteButtonInstitutionView(AppInstitution institution)
  {
    return Material(
      color: themeColor,
      child: InkWell(
        child: Icon(
          MaterialCommunityIcons.trash_can_outline,
          size: MediaQuery.of(context).size.width * 0.016),
          onTap: () async {
            var res = await showDialog(
            context: context,
            child: DeleteAlertDialog('Da li ste sigurni da želite da izbrišete datog korisnika?'),
          );
          if(res)
          {
            showDialog(
              context: context,
              builder: (context){
                return LoadingDialog("Brisanje korisnika u toku...");
              }
            );

            await UserAPIServices.deleteUserEntity(institution.id);
            Navigator.pop(context);
            _removeInstitution(institution);
          }
        }
      ),
    );
  } 
  
  Widget makeFloatingButtonForAddingInstitution(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: FloatingActionButton(
            onPressed: () async {
              var res = await showDialog(
                context: context,
                child: CreateNewInstitution(context),
              );

              if(res != null)
                _addItemToList(res);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.grey,
        )
      )
    );
  }
  
  Widget makeInstitutionDetailScreen() 
  {
    return StreamBuilder(
      stream: _postStreamController.stream,
      builder: (context, snapshots) {
        if (!snapshots.hasData)
          return BOTFunction.loadingIndicator();
        else 
        {
          return Expanded(
            child: Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      makeInstitutionInfoDetailScreen(userInfo),
                      makeButtonsDetailScreen(),
                    ]
                  ),
                  Expanded(child: makeInstitutionPostsDetailScreen(snapshots.data)),
                ]
              )
            ),
          );
        }
      },
    );
  }

  Widget makeInstitutionInfoDetailScreen(AppInstitution userInfo) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      width: MediaQuery.of(context).size.width * 0.40,
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

  Widget makeInstitutionPostsDetailScreen(List<AppPost> postsList) {
    return Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.grey[400])
        ),
        height: MediaQuery.of(context).size.height,
        child: postsList.length == 0 ? Center(
          child: Text("Korisnik nema objave")
        ) : Container(
          child: GridView.count(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: MediaQuery.of(context).size.height * 0.003,
            crossAxisSpacing: MediaQuery.of(context).size.width * 0.002,
            childAspectRatio: MediaQuery.of(context).size.width * 0.30 / MediaQuery.of(context).size.height * 7.0,
            children: List.generate(
              postsList.length,
              (index) {
                return TilePostComponent(context,postsList[index], _removePostFromUserList);
              }
            ),
          )
        )
    );
  }

  Widget makeButtonsDetailScreen() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            makeGoBackButtonDetailScreen(),
            makeDeleteButtonDetailScreen(),
          ],
        )
      );
  }

  FlatButton makeGoBackButtonDetailScreen() 
  {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.chevron_left,
              size: MediaQuery.of(context).size.width * 0.02),
          Text('Nazad')
        ]
      ),
      onPressed: () {
        setState(() => _showInfoUser = false);
      },
    );
  }

  Widget makeDeleteButtonDetailScreen()
  {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      color: Colors.grey[300],
      child: Text('Obriši korisnika'),
      onPressed: () async 
      {
        var res = await showDialog(
          context: context,
          child: DeleteAlertDialog('Da li ste sigurni da želite da izbrišete datog korisnika?'),
        );
        if(res)
        {
          showDialog(
            context: context,
            builder: (context){
              return LoadingDialog("Brisanje korisnika u toku...");
            }
          );

          await UserAPIServices.deleteUserEntity(userInfo.id).then((value){
            Navigator.pop(context);
            _removeInstitution(userInfo);
            
            setState(() {
              userInfo = null;
              _showInfoUser = false;
            });

          });
        }
      }
    );
  }

 Container makeFieldsDetailScreen(AppInstitution institution) 
 {
    double fontSize = MediaQuery.of(context).size.width * 0.01;
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          makeNameField(fontSize, institution.name),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          makeHeadQuaterField(fontSize, institution.headquaterName),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          makeEmailField(fontSize, institution.email),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          makeJoinDateField(fontSize, institution.joinDate)
        ],
      ),
    );
  }

  Widget makeNameField(double fontSize, String name){
    return  RichText(
      text: TextSpan(
       children: [
          TextSpan(
            text: 'Naziv: ',
            style: TextStyle(color: Colors.black, fontSize: fontSize)
          ),
          TextSpan(
            text: name,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize)
          )
        ]
      ),
    );
  }

  Widget makeHeadQuaterField(double fontSize, String city){
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Sedište: ',
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

  Widget makeEmailField(double fontSize, String email){
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

  Widget makeJoinDateField(double fontSize, DateTime joinDate){
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

  Container makeProfilePhotoDetailScreen(AppInstitution userInfo) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: CircleAvatar(
        backgroundImage:
            NetworkImage(defaultServerURL + userInfo.imageURL),
        radius: MediaQuery.of(context).size.width * 0.07,
      ),
    );
  }
}

