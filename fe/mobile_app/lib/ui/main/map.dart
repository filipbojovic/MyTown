import 'dart:async';

import 'package:bot_fe/bottomNavBar.dart';
import 'package:bot_fe/components/Other/ConfirmDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/ui/main/notification.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:bot_fe/ui/sub_pages/PostAndCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:bot_fe/services/api/post.api.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  _MyMapState()
  {
    NotificationServices.selectedPage = 3;
    NotificationServices.notifController.pushToNotificationPage = _pushToNotifPage;
    NotificationServices.notifController.pushToLoginPage = _pushToLoginPage;
  }

  Future postsFuture;
  int _challengeImagesToShow;
  StreamController _imageToShowController;
  final MapController mapController = new MapController();

  _pushToNotifPage()
  {
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => UserNotification()
    ));
  }

  _showImage(int i)
  {
    _imageToShowController.add(i);
    _challengeImagesToShow = i;
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
  
  @override
  void initState() {
    super.initState();

    _imageToShowController = new StreamController();
    _showImage(-1);

    postsFuture = _getChallenges();
  }

  _getChallenges() async
  {
    return await ChallengeAPIServices.getAppChallengePosts(int.parse(loggedUserID));
  }

  @override
  void dispose() {
    _imageToShowController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: postsFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData)
              return BOTFunction.loadingIndicator();
            List<AppPost> challenges = snapshot.data;
            challenges = challenges.where((element) => element.typeID == PostTypeEnum.challengePost).toList();
            if(!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyan,
                  strokeWidth: 5,
                ),
              );
            else 
              return Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  new FlutterMap(
                    options: MapOptions(
                      center: challenges.length > 0 ? new LatLng(challenges[0].latitude, challenges[0].longitude) : LatLng(44.787197, 20.457273),
                      zoom: challenges.length > 0 ? 16.5 : 7.5,
                      maxZoom: 17.0,
                      minZoom: 8.0,
                    ),
                    mapController: mapController,
                    layers: [new TileLayerOptions(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: ['a', 'b', 'c']),
                      new MarkerLayerOptions(
                        markers: setMarkers(challenges)
                      )
                    ]
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    right: 0.0,
                    child: showChallengesOnTheMap(challenges, context)
                  ),
                ],
             ); 
            }
          ),
      ),
      bottomNavigationBar: BottomNavBar(1),
    ); 
  }
  
  List<Marker> setMarkers(List<AppPost> challenges) {
      List<Marker> markers = [];

      for(int i=0; i<challenges.length; i++)
      {            
        LatLng point = LatLng(challenges[i].latitude, challenges[i].longitude);
        markers.add( Marker(
          point: point,
          builder: (context){
            return Container(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  enableFeedback: false,
                  onTap: () {
                    _showImage(i);
                  },
                  onDoubleTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PostAndCommentScreen(challenges[i].id)));
                  },
                  child: Icon(
                    MaterialCommunityIcons.map_marker,
                    color: Colors.redAccent[700],
                    size: MediaQuery.of(context).size.width * 0.055,
                  ),
                ),
              ),
            );
          }
        )
      );
    }
    return markers;
  }

Widget showChallengesOnTheMap(List<AppPost> challenges, BuildContext context) {
  challenges = challenges.where((e) => e.typeID == PostTypeEnum.challengePost).toList();
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      StreamBuilder(
        initialData: -1,
        stream: _imageToShowController.stream,
        builder: (context, snapshot){
          if(snapshot.data != -1)
            return makeImageListView(context, challenges);
          else
            return Container();
        },
      ),
      Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.13,
        child: ListView.builder(
          itemCount: challenges.length,
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
              return makeChallengeViewOnTheMap(challenges[index], context);
            },
          ),
      ),
    ],
  );
  }

Container makeImageListView(BuildContext context, List<AppPost> challenges) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    color: Colors.transparent,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: challenges[_challengeImagesToShow].imageURLS.length,
      itemBuilder: (context, index){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.007),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(defaultServerURL +challenges[_challengeImagesToShow].imageURLS[index]),
          ),
        );
      },
    ),
  );
}

Widget makeChallengeViewOnTheMap(AppPost challenge, BuildContext context)
{
  TextStyle style = new TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.038,
    fontWeight: FontWeight.w500,
    height: MediaQuery.of(context).size.height * 0.0015,
    color: Colors.white
  );
  return  GestureDetector(
    onTap: () {
      mapController.move(new LatLng(challenge.latitude, challenge.longitude), 16.5);
      _showImage(-1);
    },
    child: Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.007, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: Colors.grey[800],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(challenge.title.length > 50 ? challenge.title.substring(0, 47) + "..." : challenge.title, softWrap: true, style: style)
              ),
              Text(
                challenge.cityName,
                style: style
              ),
              Text(BOTFunction.getChallengeRemainingTime(challenge.endDate), style: style,)
            ],
          )
        ],
      ),
    ),
  );
  }
}
