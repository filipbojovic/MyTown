import 'dart:convert';

import 'package:bot_fe/components/Other/ListUsersComponent.dart';
import 'package:bot_fe/components/Other/LoadingDialog.dart';
import 'package:bot_fe/components/Other/ReportDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppReply.dart';
import 'package:bot_fe/models/DbModels/CommentNotification.dart';
import 'package:bot_fe/models/DbModels/CommentReport.dart';
import 'package:bot_fe/services/api/comment.api.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/report.api.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:bot_fe/ui/sub_pages/UserCommentScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UsersReplyComponent extends StatefulWidget {
  
  final AppReply reply;
  final UserCommentController commentController;
  final Function _refreshRepliesOnDelete;
  final Function refreshRepliesOnAdd;
  UsersReplyComponent(this.commentController, this.reply, this._refreshRepliesOnDelete, this.refreshRepliesOnAdd, {Key key}) : super(key: key);

  @override
  _UsersReplyComponentState createState() => _UsersReplyComponentState();
}

class _UsersReplyComponentState extends State<UsersReplyComponent> {

  bool _likeEnabled = true;

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeReply();
  }

  Widget makeReply() {
    return GestureDetector(
      onLongPress: () {
        makePopUpMenu(context);
      },
        child: Container(
          color: Colors.white,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
          top: MediaQuery.of(context).size.width * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                makeProfilePhoto(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        makeReplyText(),
                        makeLikeButton(),
                        ],
                      ),
                      SizedBox(height: 5.0,),
                      makeLikeAnswerRow(),
                    ],
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }

  Widget makeProfilePhoto() {
    return GestureDetector(
      onTap: (){
        if(widget.reply.userTypeID != PostTypeEnum.institutionPost)
          Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(widget.reply.userID, widget.reply.userID != loggedUser.id ?  false : true)));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 5.0,
          right: 3.0
        ),
        child: CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.04,
          backgroundImage: NetworkImage(defaultServerURL +widget.reply.profileImage),
        ),
      ),
    );
  }

  makePopUpMenu(BuildContext _context)
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
                  if(widget.reply.userID == int.parse(loggedUserID)) 
                    ListTile(
                      title: Row(
                        children: [
                          Icon(MaterialCommunityIcons.trash_can_outline),
                          SizedBox(width: 5.0),
                          Text(
                            'Obriši',
                            style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04),
                          ),
                        ],
                      ),
                      onTap: () async {
                        

                        showDialog(
                          context: _context,
                          barrierDismissible: false,
                          builder: (context){
                            return LoadingDialog("Brisanje komentara...");
                          }
                        );

                        await CommentAPIServices.deleteComment(widget.reply.id, widget.reply.postID).
                          then((value){
                            Navigator.pop(_context);
                            Navigator.pop(context);
                            widget._refreshRepliesOnDelete(widget.reply.id, widget.reply.postID);
                          });
                      }
                    ),
                  if(widget.reply.userID != int.parse(loggedUserID)) 
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
                        child: ReportDialog(widget.reply.fullName),
                      );
                      if(text != null)
                      {
                        await ReportAPIServices.addCommentReport(new CommentReport(widget.reply.postID, widget.reply.id, int.parse(loggedUserID), widget.reply.userID, DateTime.now(), text)).then((value){
                          // if(value)
                            //BOTFunction.showSnackBar("Uspešno ste poslali žalbu.", widget._scaffoldKey);
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

  Widget makeLikeButton() {
    return Material(
      child: GestureDetector(
        onTap: () async 
        {
          if(!widget.reply.likedByUser) //ako nije lajkovano
          {
            if(!_likeEnabled)
              return;
            
            setState(() => _likeEnabled = false);
            await CommentAPIServices.addCommentLike(widget.reply.id, widget.reply.postID, int.parse(loggedUserID), 1).then((value){
              print('ok');
              if(value == -1)
                print('losa konekcija');
              else
                setState(() {
                  widget.reply.setLikes = value;
                  widget.reply.setLikedByUser = true;
                });
            });
            if(widget.reply.userTypeID != UserTypeEnum.institution && loggedUser.id != widget.reply.userID)
            {
              CommentNotification cn = new CommentNotification(int.parse(loggedUserID), widget.reply.userID, widget.reply.postID, widget.reply.id, NotificationTypeEnum.commentLike, false, DateTime.now());
              NotificationServices.channel.sink.add(jsonEncode(cn.toMap()));
            }
          }
          else
          {
            await CommentAPIServices.deleteCommentLike(widget.reply.id, widget.reply.postID, int.parse(loggedUserID)).then((value){
              if(value == -1)
                print('losa konekcija');
              else
                setState(() {
                  widget.reply.setLikes = value;
                  widget.reply.setLikedByUser = false;
                });
            });
          }
          setState(() => _likeEnabled = true);      
        },
        child: Icon(widget.reply.likedByUser == true? MaterialCommunityIcons.tree : MaterialCommunityIcons.tree_outline, size: 18.0, color: Colors.green[500],)
      ),
    );
  }

  Widget makeLikeAnswerRow(){
    var textStyleBold = TextStyle(
        color: Colors.grey[900],
        fontWeight: FontWeight.bold
      );
      var textStyle = TextStyle(
        color: Colors.grey[900],
      );
    return Row(
      children: <Widget>[
        Text(BOTFunction.getReplyTimeDifference(widget.reply.date) +" ", style: textStyle),

        widget.reply.likes > 0 ? GestureDetector(
          child: Text(
            widget.reply.likes.toString() +" sviđanja",
            style: widget.reply.likedByUser == true? textStyleBold : textStyle
          ),
          onTap: (){
            _showListOfUsersWhoLikesThis();
          },
        ) : Container(),
        
        Material(
          child: InkWell(
            enableFeedback: false,
            onTap: (){
              widget.commentController.refreshRepliesOnAdd = widget.refreshRepliesOnAdd;
              widget.commentController.changeReplyStatus(true, widget.reply.fullName,  widget.reply.userID, widget.reply.parrentID, widget.reply.userTypeID);
              //makeCommentField();
            },
            child: Text(
              ' Odgovori',
              style: textStyle
            ),
          )
        )
      ],
    ) ;
  }
  
  _showListOfUsersWhoLikesThis()
  {
    showModalBottomSheet(context: context, 
      backgroundColor: Colors.transparent,
        builder: (BuildContext context){
          return ListUsersComponent(widget.reply.postID, widget.reply.id);
        }
    );
  }

  Widget makeReplyText()
  {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.01, horizontal: MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0)
      ),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.77,),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            makeUserFullName(),
            makeTextNextToUserName(),
          ]
        ),
      ),
    );
  }

  TextSpan makeTextNextToUserName() {
    return TextSpan(
      text: widget.reply.text,
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.037
      )
    );
  }

  TextSpan makeUserFullName() {
    return TextSpan(
      recognizer: TapGestureRecognizer()..onTap = () => widget.reply.userTypeID != PostTypeEnum.institutionPost ?
          Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(widget.reply.userID, widget.reply.userID != loggedUser.id ?  false : true))) : null,
      text: widget.reply.fullName +" ",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.037
      )
    );
  }
}