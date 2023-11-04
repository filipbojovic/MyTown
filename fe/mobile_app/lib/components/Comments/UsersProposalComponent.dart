import 'dart:async';
import 'dart:convert';
import 'package:bot_fe/components/Comments/EditCommentDialog.dart';
import 'package:bot_fe/components/Comments/FullScreenPhoto.dart';
import 'package:bot_fe/components/Comments/UserCommentComponent.dart';
import 'package:bot_fe/components/Other/ListUsersComponent.dart';
import 'package:bot_fe/components/Other/ReportDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppProposal.dart';
import 'package:bot_fe/models/DbModels/CommentNotification.dart';
import 'package:bot_fe/models/DbModels/CommentReport.dart';
import 'package:bot_fe/services/api/comment.api.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/report.api.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:bot_fe/ui/sub_pages/UserCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'RepliesComponent.dart';

class UsersProposalComponent extends StatefulWidget {
  final AppProposal proposal;
  final UserCommentController commentController;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  UsersProposalComponent(this.commentController, this.proposal, this._scaffoldKey, {Key key}) : super(key: key);

  @override
  _UsersProposalComponentState createState() => _UsersProposalComponentState();
}

class _UsersProposalComponentState extends State<UsersProposalComponent> with AutomaticKeepAliveClientMixin {

  final UserReplyController _replyController = new UserReplyController();

  StreamController _textStreamController = new StreamController();

  _setUpStream()
  {
    _textStreamController.stream.listen((value) {
      widget.proposal.setText = value;
    });
  }

  _updateCommentText(String text)
  {
    if(!mounted)
      _textStreamController.add(text);
    else
    {
      setState(() {
        widget.proposal.setText = text;
      });
    }
  }

  Image image;
  String address = '';
  bool _likeEnabled = true;

  @override
  void initState() {
    _setUpStream();
    _textStreamController.add(widget.proposal.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeProposal(context);
  }

  Widget makeProposal(BuildContext context) {
    return Container(
      color: widget.proposal.userTypeID == UserTypeEnum.user ? Colors.white : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            makeHeader(),
            Container(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  makeCommentText(),
                  if(widget.proposal.images.length > 0)
                    makeImageView(widget.proposal.images),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                makeThankYouButton(),
                widget.proposal.likes != 0 ? makeLikeCount() : Container(),
                makeThumbDownButton(),
                makeReplyButton(),
              ],
            ),
            RepliesComponent(widget.commentController, _replyController, widget.proposal.replies, key: UniqueKey(),)
          ],
        ),
      ),
    );
  }

  Row makeHeader() {
    return Row( //row for avatar, fullname, rank
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row( //[{avatar}, {ime,rank}]
          children: <Widget>[
            makeProfilePhoto(),
            SizedBox(width: 8.0),
            Column( //za imeprezime + rank
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                makeFullNameLabel(),
                SizedBox(height: 3.0,),
                makeDateLabel(context),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            makePopUpMenu();
          },
          icon: Icon(MaterialCommunityIcons.dots_horizontal),
        ),
      ],
    );
  }

  Widget makeProfilePhoto() {
    return GestureDetector(
      onTap: (){
        if(widget.proposal.userTypeID != PostTypeEnum.institutionPost)
          Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(widget.proposal.userID, widget.proposal.userID != loggedUser.id ?  false : true)));
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(defaultServerURL +widget.proposal.profileImage),
        radius: MediaQuery.of(context).size.width * 0.05,
      ),
    );
  }

  Widget makeFullNameLabel() {
    return Material(
      child: InkWell(
        onTap: (){
          if(widget.proposal.userID != loggedUser.id && widget.proposal.userTypeID != UserTypeEnum.institution)
            Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(widget.proposal.userID, false)));
        },
        enableFeedback: false,
        child: Text(
          widget.proposal.firstName +" " +widget.proposal.lastName,
          style: TextStyle(
            color: widget.proposal.userTypeID == UserTypeEnum.user ? Colors.grey[900] : Colors.orange[900],
            fontWeight: FontWeight.bold,
            fontSize: 15.0
          )
        ),
      ),
    );
  }

  Container makeDateLabel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(BOTFunction.getTimeDifference(widget.proposal.date))
        ],
      )
    );
  }

  makePopUpMenu()
  {
    TextEditingController _commentController = new TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context){
        return Wrap(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))
              ),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  // if(widget.proposal.userID == int.parse(loggedUserID)) 
                  //   ListTile(
                  //     title: Row(
                  //       children: [
                  //         Icon(MaterialCommunityIcons.trash_can_outline),
                  //         SizedBox(width: 5.0),
                  //         Text(
                  //           'Obriši',
                  //           style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04),
                  //         ),
                  //       ],
                  //     ),
                  //     onTap: () async {
                  //       Navigator.pop(context);

                  //       showDialog(
                  //         context: context,
                  //         barrierDismissible: false,
                  //         child: LoadingDialog("Brisanje komentara..."),
                  //       );

                  //       await CommentAPIServices.deleteComment(widget.proposal.id, widget.proposal.postID)
                  //         .then((value){
                  //           widget.commentController.refreshCommentOnDelete(widget.proposal.id, widget.proposal.postID);
                  //           Navigator.pop(context);
                  //         });
                  //     }
                  //   ),
                  if(widget.proposal.userID == int.parse(loggedUserID)) 
                    ListTile(
                      title: Row(
                        children: [
                          Icon(MaterialCommunityIcons.pencil_outline),
                          SizedBox(width: 5.0),
                          Text(
                            'Izmeni',
                            style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04),
                          ),
                        ],
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                    
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => EditCommentDialog(widget.proposal, _updateCommentText)
                        );
                      }
                    ),
                  if(widget.proposal.userID != int.parse(loggedUserID)) 
                  ListTile(
                    title: Row(
                      children: [
                        Icon(MaterialCommunityIcons.message_alert_outline),
                        SizedBox(width: 5.0),
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
                        child: ReportDialog(widget.proposal.fullName),
                      );
                      if(text != null)
                      {
                        await ReportAPIServices.addCommentReport(new CommentReport(widget.proposal.postID, widget.proposal.id, int.parse(loggedUserID), widget.proposal.userID, DateTime.now(), text)).then((value){
                          if(value)
                            BOTFunction.showSnackBar("Uspešno ste poslali žalbu.", widget._scaffoldKey);
                          else
                            BOTFunction.showSnackBar("Došlo je do greške.", widget._scaffoldKey);
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

  Widget makeThumbDownButton()
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: false,
          onTap: () async
          {
            if(!_likeEnabled)
              return;
            
            setState(() => _likeEnabled = false);

            if(widget.proposal.likeValue != -1) //if it is not disliked already
            {
              await CommentAPIServices.addCommentLike(widget.proposal.id, widget.proposal.postID, int.parse(loggedUserID), -1).then((value){
                if(value == null)
                  print('losa konekcija');
                else
                  setState(() {
                    widget.proposal.setLikes = value;
                    widget.proposal.setLikeValue = -1;
                  });
              });
              if(widget.proposal.userTypeID != UserTypeEnum.institution  && loggedUser.id != widget.proposal.userID)
              {
                CommentNotification cn = new CommentNotification(int.parse(loggedUserID), widget.proposal.userID, widget.proposal.postID, widget.proposal.id, NotificationTypeEnum.commentLike, false, DateTime.now());
                NotificationServices.channel.sink.add(jsonEncode(cn.toMap()));
              }
            }
            else
            {
              await CommentAPIServices.deleteCommentLike(widget.proposal.id, widget.proposal.postID, int.parse(loggedUserID)).then((value){
                if(value == null)
                  print('losa konekcija');
                else
                  setState(() {
                    widget.proposal.setLikes = value;
                    widget.proposal.setLikeValue = 0;
                  });
              });
            }

            setState(() => _likeEnabled = true);
          },
          child: Row(
            children: <Widget>[
              Icon(
                widget.proposal.likeValue == -1 ? MaterialCommunityIcons.thumb_down : MaterialCommunityIcons.thumb_down_outline,
                color: widget.proposal.likeValue == -1 ? Colors.green : Colors.grey[800],
                size: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(width: 3.0,),
              Text(
                'Može bolje',
                style: TextStyle(
                  color: widget.proposal.likeValue == -1 ? Colors.green : Colors.grey[800],
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeLikeCount(){
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          //'100k',
          widget.proposal.likes.toString(),
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

      onTap: () {
        _showListOfUsersWhoLikesThis();
      },
    );
  } 
  _showListOfUsersWhoLikesThis()
  {
    showModalBottomSheet(context: context, 
      backgroundColor: Colors.transparent,
        builder: (BuildContext context){
          return ListUsersComponent(widget.proposal.postID, widget.proposal.id);
        }
    );
  }

  Widget makeThankYouButton()
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: false,
          onTap: () async
          {
            if(!_likeEnabled)
              return;
            print("aa");
            setState(() => _likeEnabled = false);
            
            if(widget.proposal.likeValue != 1) //if it is not liked already
            {
              await CommentAPIServices.addCommentLike(widget.proposal.id, widget.proposal.postID, int.parse(loggedUserID), 1).then((value){
                if(value == null)
                  print('losa konekcija');
                else
                  setState(() {
                    widget.proposal.setLikes = value;
                    widget.proposal.setLikeValue = 1;
                  });
                  if(widget.proposal.userTypeID != UserTypeEnum.institution && loggedUser.id != widget.proposal.userID)
                  {
                    CommentNotification cn = new CommentNotification(int.parse(loggedUserID), widget.proposal.userID, widget.proposal.postID, widget.proposal.id, NotificationTypeEnum.commentLike, false, DateTime.now());
                    NotificationServices.channel.sink.add(jsonEncode(cn.toMap()));
                  }
              });
            }
            else
            {
              await CommentAPIServices.deleteCommentLike(widget.proposal.id, widget.proposal.postID, int.parse(loggedUserID)).then((value){
                if(value == null)
                  print('losa konekcija');
                else
                  setState(() {
                    widget.proposal.setLikes = value;
                    widget.proposal.setLikeValue = 0;
                  });
              });
            }

            setState(() => _likeEnabled = true);
          },
            child: Row(
            children: <Widget>[
              Icon(
                widget.proposal.likeValue == 1 ? MaterialCommunityIcons.thumb_up : MaterialCommunityIcons.thumb_up_outline,
                color: widget.proposal.likeValue == 1 ? Colors.green : Colors.grey[800],
                size: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(width: 3.0,),
              Text(
                'Hvala',
                style: TextStyle(
                  color: widget.proposal.likeValue == 1 ? Colors.green : Colors.grey[800],
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeReplyButton()
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: false,
          onTap: () {
            widget.commentController.refreshRepliesOnAdd = _replyController.refreshRepliesOnAdd;
            widget.commentController.changeReplyStatus(true, widget.proposal.fullName, widget.proposal.userID, widget.proposal.id, widget.proposal.userTypeID);
          },
          child: Row(
            children: <Widget>[
              Icon(
                MaterialCommunityIcons.reply_all_outline,
                color: Colors.grey[800],
                size: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(width: 3.0,),
              Text(
                'Odgovori',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeCommentText()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0)
      ),
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.01, horizontal: MediaQuery.of(context).size.width * 0.02),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.proposal.text,
            softWrap: true,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.037,
            ),
          ),
        ],
      ),
    );
  }

  Widget makeImageView(List<String> images) //display for images in the proposal
  {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      //width: MediaQuery.of(context).size.height * 0.12,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DetailScreen(defaultServerURL +images[index]);
              }));
            },
            child: Hero(
              tag: 'imageHero' +defaultServerURL +images[index],
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.01,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(defaultServerURL +images[index]),
                  )
                ),
                height: MediaQuery.of(context).size.height * 0.11,
                width: MediaQuery.of(context).size.width * 0.17,
                child: Container()
                ),
            ),
          );
          }
        ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}