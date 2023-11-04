import 'dart:async';
import 'dart:convert';
import 'package:bot_fe/components/Other/ConfirmDialog.dart';
import 'package:bot_fe/components/Other/ImageSliderComponent.dart';
import 'package:bot_fe/components/Other/ListUsersComponent.dart';
import 'package:bot_fe/components/Other/LoadingDialog.dart';
import 'package:bot_fe/components/Other/PopUpMap.dart';
import 'package:bot_fe/components/Other/ReportDialog.dart';
import 'package:bot_fe/components/PostComponents/EditPostDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/models/DbModels/AcceptedChallenge.dart';
import 'package:bot_fe/models/DbModels/PostNotification.dart';
import 'package:bot_fe/models/DbModels/PostReport.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:bot_fe/services/api/report.api.dart';
import 'package:bot_fe/services/location.services.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:bot_fe/ui/sub_pages/UserCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ChallengePostComponent extends StatefulWidget {
  final AppPost post;
  final Function refresh;
  final Function refreshHomePage;
  final bool standardView;

  ChallengePostComponent(this.standardView, this.refreshHomePage, this.refresh, this.post,
      {Key key})
      : super(key: key);
  @override
  _ChallengePostComponentState createState() =>
      _ChallengePostComponentState(post);
}

class _ChallengePostComponentState extends State<ChallengePostComponent> {
  AppPost post;
  var address = '';
  _ChallengePostComponentState(this.post);
  
  String time = '';

  StreamController _timeStreamController;
  Stream _stream;
  Timer timer;
  bool _likeEnabled;
  // _loadLocation() async {
  //   Location.getFullAddress(post.latitude, post.longitude).then((value) async {
  //     if (this.mounted) {
  //       setState(() {
  //         address = value.locality != null ? value.locality : value.addressLine;
  //       });
  //     }
  //   });
  // }

  
  _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (DateTime.now().isBefore(post.endDate))
        _timeStreamController
            .add(BOTFunction.getChallengeRemainingTime(post.endDate));
      else {
        timer.cancel();
        setState(() {
          timer = null;
        });
      }
    });
  }
  
  _setStream() {
    _timeStreamController = new StreamController.broadcast();
    _stream = _timeStreamController.stream;
  }

  StreamController _textStreamController = new StreamController();

  _setEditStream()
  {
    _textStreamController.stream.listen((event) {
      post.setTitle = event["title"];
      post.setDescription = event["description"];
      post.setEndDate = DateTime.parse(event["endDate"]);
      widget.refreshHomePage();
    });
  }

  @override
  void initState() {
    _setStream();
    _setEditStream();
    _likeEnabled = true;
    if (DateTime.now().isBefore(post.endDate)) _startTimer();
    address = post.cityName;
    super.initState();
  }

  @override
  void dispose() {

    _timeStreamController.close();
    if (timer != null) timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 5.0),
        child: Padding(
          padding: EdgeInsets.only(
            top: 3.0,
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Column(
            //represents each row in post
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              makeHeader(context),
              SizedBox(height: 5.0),
              makeTitle(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              makeImageScreen(),
              if(widget.post.imageURLS.length == 1) SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              makeDescriptionField(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              if(widget.standardView) makeChallengeCount(),
              SizedBox(height: 5.0),
              makeFooter()
            ],
          ),
        ),
      ),
    );
  }

  Container makeFooter() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Colors.grey[900], width: 0.3),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          makeFullLikeButton(),
          if(widget.standardView) makeCommentButton(),
          if(!widget.standardView) makeChallengeCount(),
          if(!post.acceptedByTheUser && post.endDate.isAfter(DateTime.now()))
          if(loggedUser.id != widget.post.userEntityID) makeAcceptButton(),
          if (post.solvedByTheUser == 1)
            Container(
              child: Text('Postavili ste rešenje.',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.034
                )
              )
            )
          //0 - still not solved; -1 - gave up
        ],
      ),
    );
  }

  Row makeFullLikeButton() {
    return Row(
      children: <Widget>[
        post.likes > 0 ? makeLikeCount() : Container(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        ),
        makeLikeButton(post.likedByUser, setState),
      ],
    );
  }

  Row makeChallengeCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            post.endDate.isBefore(DateTime.now()) ? Text(
              'Vreme je isteklo.',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.bold,
                color: footerInActiveColor,
              ),
            ) : 
            StreamBuilder(
              stream: _stream,
              builder: (context, streamData) {
                if (!streamData.hasData)
                  return Text(
                    BOTFunction.getChallengeRemainingTime(post.endDate),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.036
                    ),
                  );
                else
                  return Text(
                    streamData.data.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.036
                    ),
                  );
              },
            )
          ],
        ),
        if(widget.standardView) Text(
          post.comments.toString() + ' rešenje/a',
          style: boldText
        ),
      ],
    );
  }

  Widget makeImageScreen() {
    return widget.post.imageURLS != null
      ? ImageSliderComponent(widget.post.imageURLS)
      : Container();
  }

  Text makeTitle() {
    return Text(post.title,
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: MediaQuery.of(context).size.width * 0.055,
        fontWeight: FontWeight.bold
      )
    );
  }

  Row makeHeader(BuildContext _context) {
    return Row(
      // a row which contains: the row with picture and username/date | iconButton
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          //a row which contains a picture | column with username/date
          children: <Widget>[
            makeProfilePhoto(context),
            SizedBox(width: MediaQuery.of(context).size.width * 0.012),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                makeFullNameLabel(context),
                SizedBox(height: 3.0),
                makeTimeAndLocation(),
              ],
            )
          ],
        ),
        makeMenuButton(_context)
      ],
    );
  }

  IconButton makeMenuButton(BuildContext _context) {
    return IconButton(
      icon: Icon(
        MaterialCommunityIcons.dots_horizontal,
        size: MediaQuery.of(context).size.width * 0.08,
        color: Colors.grey[900],
      ),
      onPressed: () async {
        var res = await ChallengeAPIServices.postExistance(widget.post.id);
        
        if(res == "true")
          makePopUpMenu(_context);
        else
        {
          showDialog(
            context: _context,
            child: ConfirmDialog("Ovaj sadržaj više nije dostupan.")
          );
        }
      },
    );
  }

  Material makeFullNameLabel(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: (){
          if(widget.post.typeID != PostTypeEnum.institutionPost)
            Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(widget.post.userEntityID, widget.post.userEntityID != loggedUser.id ?  false : true)));
        },
        enableFeedback: false,
        child: Text(post.fullName,
          style: TextStyle(
              color: Colors.grey[900],
              fontSize: MediaQuery.of(context).size.width * 0.043,
              fontWeight: FontWeight.bold
              )
            ),
      ),
    );
  }

  Widget makeProfilePhoto(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.post.typeID != PostTypeEnum.institutionPost)
          Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(widget.post.userEntityID, widget.post.userEntityID != loggedUser.id ?  false : true)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.12,
        height: MediaQuery.of(context).size.width * 0.12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(defaultServerURL +
                post.userProfilePhotoURL
              ),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }

  RichText makeDescriptionField() {
    return RichText(
      text: TextSpan(
        text: post.description,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.042,
          color: Colors.black,
        )
      ),
      softWrap: true,
    );
  }

  makePopUpMenu(BuildContext _context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0)
                )
              ),
              child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                if (post.userEntityID == int.parse(loggedUserID))
                ListTile(
                  title: Row(
                    children: [
                      Icon(MaterialCommunityIcons.trash_can_outline),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                      Text(
                        'Obriši',
                        style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ],
                  ),
                  onTap: () async {
                    

                    showDialog(
                      context: _context,
                      builder: (context){
                        return LoadingDialog("Brisanje izazova...");
                      },
                      barrierDismissible: false,
                    );
                        
                    await ChallengeAPIServices.deletePost(post.id)
                      .then((value){
                        Navigator.pop(_context);
                        Navigator.pop(context);
                        
                        if(widget.standardView) 
                          widget.refresh(post.id);
                        else
                          Navigator.pop(context);
                        
                      });
                  }
                ),
                if (post.userEntityID == int.parse(loggedUserID))
                ListTile(
                  title: Row(
                    children: [
                      Icon(MaterialCommunityIcons.pencil_outline),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                      Text(
                        'Izmeni',
                        style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ],
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    
                    var data = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EditPostScreen(post)
                    );

                    if(data != null)
                      _textStreamController.add(data);
                  }
                ),
                if (post.userEntityID != int.parse(loggedUserID)) ListTile(
                  title: Row(
                    children: [
                      Icon(MaterialCommunityIcons.message_alert_outline),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                      Text(
                        'Pošalji žalbu',
                        style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ],
                  ), 
                  onTap: () async {
                    Navigator.pop(context);
                    var text = await showDialog(
                      context: context,
                      builder: (context){
                        return ReportDialog(widget.post.fullName);
                      }
                    );
                    if(text != null)
                    {
                      await ReportAPIServices.addPostReport(new PostReport(widget.post.id, int.parse(loggedUserID), widget.post.userEntityID, DateTime.now(), text)).then((value){
                        // if(value)
                        //   BOTFunction.showSnackBar("Uspešno ste poslali žalbu.", widget._scaffoldKey);
                        // else
                        //   BOTFunction.showSnackBar("Došlo je do greške.", widget._scaffoldKey);
                      });
                    }
                  }
                ),
                ],
              )
            ),
          ]
        );
      }
    );
  }

  Widget makeTimeAndLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          BOTFunction.getTimeDifference(post.date),
          style: TextStyle(color: Colors.grey[600], fontSize: 15.0)
        ),
        GestureDetector(
          onTap: (){
            showDialog(
              context: context,
              builder: (context){
                return PopUpMap(post.latitude, post.longitude);
              }
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.62,
            child: Text(
              address,
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            )
          ),
        ),
      ],
    );
  }

  Widget makeLikeCount() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          //'100k',
          post.likes.toString(),
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.036,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 2.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                1.0, // horizontal, move right 10
                1.0, // vertical, move down 10
              ),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.003,
          horizontal: MediaQuery.of(context).size.width * 0.01
        ),
      ),

      onTap: () async {
        var res = await ChallengeAPIServices.postExistance(widget.post.id);
        
        if(res == "true")
          _showListOfUsersWhoLikesThis();
        else
        {
          showDialog(
            context: context,
            child: ConfirmDialog("Ovaj sadržaj više nije dostupan.")
          );
        }
      },
    );
  }

  Widget makeLike() {
    return Container(
      width: 25.0,
      height: 25.0,
      decoration: BoxDecoration(
          color: Colors.green[800],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(
          Icons.thumb_up,
          size: 15.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget makeLikeButton(bool isActive, StateSetter setState) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.007),
      child: Material(
        child: InkWell(
          enableFeedback: false,
          child: Row(
            children: [
              Icon(
                isActive ? MaterialCommunityIcons.thumb_up : MaterialCommunityIcons.thumb_up_outline,
                color: isActive ? footerColor : footerInActiveColor,
                size: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Text(
                "Sviđa mi se",
                style: TextStyle(
                  color: isActive ? footerColor : footerInActiveColor,
                  fontSize: MediaQuery.of(context).size.width * 0.034,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          onTap: () async
          {
            if(!_likeEnabled)
              return;

            setState(() => _likeEnabled = false); //user must wait to response from the server.
            
            if (!post.likedByUser) //ako nije lajkovano
            {
              await ChallengeAPIServices.addPostLike(post.id, int.parse(loggedUserID))
                  .then((value) {
                if (value.toString() == "400")
                  print('losa konekcija');
                else if(value.toString() == "404")
                {
                  showDialog(
                    context: context,
                    child: ConfirmDialog("Sadržaj na koji reagujete nije dostupan.")
                  );
                }
                else
                {
                  setState(() {
                    post.setLikeCount = value;
                    post.setLikedByUser = true;
                  });

                  if(loggedUser.id != widget.post.userEntityID)
                  {
                    PostNotification pn = new PostNotification(int.parse(loggedUserID), post.userEntityID, post.id, NotificationTypeEnum.postLike, false, DateTime.now());
                    NotificationServices.channel.sink.add(jsonEncode(pn.toMap()));
                  }
                }
              });
            } 
            else 
            {
              await ChallengeAPIServices.deletePostLike(post.id, int.parse(loggedUserID))
                  .then((value) {
                if (value.toString() == "400")
                  print('losa konekcija');
                else if(value.toString() == "404")
                {
                  showDialog(
                    context: context,
                    child: ConfirmDialog("Sadržaj na koji reagujete nije dostupan.")
                  );
                }
                else
                  setState(() {
                    post.setLikeCount = value;
                    post.setLikedByUser = false;
                  });
              });
            }
            setState(() => _likeEnabled = true);
          },
        ),
      ),
    );
  }

  _showListOfUsersWhoLikesThis() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ListUsersComponent(post.id, null);
      }
    );
  }

  Widget makeCommentButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.007),
      child: Material(
        child: InkWell(
          enableFeedback: false,
          child: Row(
            children: [
              Icon(
                MaterialCommunityIcons.nature_people,
                color: Colors.grey[800],
                size: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                (post.acceptedByTheUser && post.solvedByTheUser == 0) ? "Postavite rešenje" : "Rešenja",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.034
                ),
              ),
            ],
          ),
          onTap: () async {
            var res = await ChallengeAPIServices.postExistance(widget.post.id);

            if(res == "true")
            {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserCommentScreen(post, true, null))).then((value){
                  widget.refreshHomePage();
                });
            }
            else
            {
              showDialog(
                context: context,
                child: ConfirmDialog("Ovaj sadržaj više nije dostupan.")
              );
            }
          },
        ),
      ),
    );
  }

  Widget makeAcceptButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.007),
      child: GestureDetector(
        child: Row(
          children: [
            Icon(MaterialCommunityIcons.flag_variant_outline,
              color: Colors.grey[800],
              size: MediaQuery.of(context).size.width * 0.05,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              "Prihvati izazov",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: MediaQuery.of(context).size.width * 0.034,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        onTap: () async {
          var res = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    elevation: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Da li ste sigurni da želite da prihvatite izazov?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                color: Colors.green,
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text('Prihvati'),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text('Odustani'),
                              )
                            ],
                          )
                        ],
                      ),
                    ));
              });
          if (res) {
            AcceptedChallenge challenge =
                new AcceptedChallenge(post.id, int.parse(loggedUserID));
            if (post.endDate.isBefore(DateTime.now())) {
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: Text("Neuspešno.Izazov je istekao."),
                duration: Duration(seconds: 1),
              ));
              return;
            }
            if(loggedUser.numOfAcceptedChallenges == 3)
            {
              showDialog(
                context: context,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                  content: Text(
                    'Ne možete imati više od 3 prihvaćena izazova u jednom trenutku.\nNa strani vašeg profila možete odustati od nekog izazova.',
                    style: TextStyle(
                      color: Colors.black
                    ),
                  ),
                  actions: [
                    RaisedButton(
                      color: Colors.green,
                      child: Text(
                        'U redu',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              );
              return;
            }
            var res = await ChallengeAPIServices.acceptChallenge(challenge);
            if (res != null)
              setState(() {
                loggedUser.setNumOfAcceptedChallenges = loggedUser.numOfAcceptedChallenges + 1;
                post.setAcceptedByTheUser = true;
              });
          }
        },
      ),
    );
  }
  
  TextStyle myTextStyle() {
    return TextStyle(
      fontSize: 17.0,
    );
  }
}
