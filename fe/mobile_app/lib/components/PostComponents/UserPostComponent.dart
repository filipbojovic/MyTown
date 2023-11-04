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
import 'package:bot_fe/models/DbModels/PostNotification.dart';
import 'package:bot_fe/models/DbModels/PostReport.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:bot_fe/services/api/report.api.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:bot_fe/ui/sub_pages/UserCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserPostComponent extends StatefulWidget {

  final AppPost post;
  final Function refreshOnDelete;
  final Function refreshHomePage;
  final bool standardView;

  UserPostComponent(this.standardView, this.refreshHomePage, this.post, this.refreshOnDelete, {Key key}) : super(key: key);

  @override
  _UserPostComponentState createState() => _UserPostComponentState();
}

class _UserPostComponentState extends State<UserPostComponent> {

  // final AppPost post;
  // _UserPostComponentState(this.post);
  String address = '';
  StreamController _textStreamController = new StreamController();
  bool _likeEnabled = true;

  _setUpStream()
  {
    _textStreamController.stream.listen((event) {
      widget.post.setDescription = event["description"];
    });
  }

  @override
  void initState() {
    //_loadLocation();
    _setUpStream();
    super.initState();
  }

  @override
  void dispose() {
    //_textStreamController.close();
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              if(widget.post.title != null) makeTitle(),
              if(widget.post.title != null) SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              if(widget.post.imageURLS.length > 0) ImageSliderComponent(widget.post.imageURLS),
              if(widget.post.imageURLS.length == 1) SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              makeDescriptionField(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
          top: BorderSide(color: Colors.grey[900], width: 0.4),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              widget.post.likes > 0 ? makeLikeCount() : Container(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              makeLikeButton(widget.post.likedByUser, setState),
            ],
          ),
          if(widget.post.typeID != PostTypeEnum.institutionPost && widget.standardView)Row(
            children: [
              widget.post.comments > 0 ? makeCommentCount() : Container(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              makeCommentButton(),
            ],
          ),
        ],
      ),
    );
  }

  Text makeTitle() {
    return Text(widget.post.title,
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: 22.0,
        fontWeight: FontWeight.bold
      )
    );
  }

  Row makeHeader(BuildContext _context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            makeProfilePhoto(),
            SizedBox(width: MediaQuery.of(context).size.width * 0.012),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                makeFullName(),
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

  Material makeFullName() {
    return Material(
      child: InkWell(
        enableFeedback: false,
        onTap: (){
          if(widget.post.typeID != PostTypeEnum.institutionPost)
            Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(widget.post.userEntityID, widget.post.userEntityID != loggedUser.id ?  false : true)));
        },
        child: Text(widget.post.fullName,
          style: TextStyle(
            color: widget.post.institution ? Colors.orange[900] : Colors.grey[900],
            fontSize: MediaQuery.of(context).size.width * 0.043,
            fontWeight: FontWeight.bold
            )
          ),
      ),
    );
  }

  Widget makeProfilePhoto() {
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
            image: NetworkImage(defaultServerURL + widget.post.userProfilePhotoURL),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }

  RichText makeDescriptionField() {
    return RichText(
      text: TextSpan(
        text: widget.post.description,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.042,
          color: Colors.black,
        )
      ),
      softWrap: true,
    );
  }

  makePopUpMenu(BuildContext _context) {
    TextEditingController _commentController = new TextEditingController();
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
                if (widget.post.userEntityID == int.parse(loggedUserID))
                ListTile(
                  title: Row(
                    children: [
                      Icon(MaterialCommunityIcons.trash_can_outline),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
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
                        return LoadingDialog("Brisanje objave...");
                      },
                      barrierDismissible: false,
                    );

                    await ChallengeAPIServices.deletePost(widget.post.id)
                      .then((value) async {
                        Navigator.pop(_context);
                        Navigator.pop(context);

                        if(widget.standardView) 
                            widget.refreshOnDelete(widget.post.id);
                        else
                          Navigator.pop(context);
                          
                      });
                  }
                ),
                if (widget.post.userEntityID == int.parse(loggedUserID))
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
                      builder: (context) => EditPostScreen(widget.post)
                    );
                    
                    if(data != null)
                      _textStreamController.add(data);
                  }
                ),
                if (widget.post.userEntityID != int.parse(loggedUserID))
                ListTile(
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
        Text(BOTFunction.getTimeDifference(widget.post.date),
            style: TextStyle(color: Colors.grey[600], fontSize: 15.0)),
        if(widget.post.typeID == PostTypeEnum.challengePost) GestureDetector(
          onTap: (){
            showDialog(
              context: context,
              builder: (context){
                return PopUpMap(widget.post.latitude, widget.post.longitude);
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
          widget.post.likes.toString(),
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

  Widget makeCommentCount() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          widget.post.comments.toString(),
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
    );
  }

  Widget makeLike() {
    return Container(
      width: 25.0,
      height: 25.0,
      decoration: BoxDecoration(
          color: Colors.red,
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
                color: isActive ? footerColor : Colors.grey[900],
                size: MediaQuery.of(context).size.width * 0.06,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Sviđa mi se",
                style: TextStyle(
                  color: isActive ? footerColor : footerInActiveColor,
                  fontSize: MediaQuery.of(context).size.width * 0.037,
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
            if (!widget.post.likedByUser) //ako nije lajkovano
            {
              await ChallengeAPIServices.addPostLike(widget.post.id, int.parse(loggedUserID))
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
                    widget.post.setLikeCount = value;
                    widget.post.setLikedByUser = true;
                  });

                  if(widget.post.typeID != PostTypeEnum.institutionPost && loggedUser.id != widget.post.userEntityID)
                  {
                    PostNotification pn = new PostNotification(int.parse(loggedUserID), widget.post.userEntityID, widget.post.id, NotificationTypeEnum.postLike, false, DateTime.now());
                    NotificationServices.channel.sink.add(jsonEncode(pn.toMap()));
                  }
                }
              });
            } 
            else 
            {
              await ChallengeAPIServices.deletePostLike(widget.post.id, int.parse(loggedUserID))
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
                    widget.post.setLikeCount = value;
                    widget.post.setLikedByUser = false;
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
        return ListUsersComponent(widget.post.id, null);
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
                MaterialCommunityIcons.message_outline,
                color: footerInActiveColor,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Komentari",
                style: TextStyle(
                  color: footerInActiveColor,
                  fontSize: MediaQuery.of(context).size.width * 0.037,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          onTap: () async {
            var res = await ChallengeAPIServices.postExistance(widget.post.id);

            if(res == "true")
            {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserCommentScreen(widget.post, true, null))).then((value){
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
  
  TextStyle myTextStyle() {
    return TextStyle(
      fontSize: 17.0,
    );
  }
}