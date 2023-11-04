import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Post/CommentScreen.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppReply.dart';
import 'package:web_app/services/storage.services.dart';

import '../../services/api/comment.api.dart';

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

  int likes;
  bool liked;

  @override
  void initState() {
    likes = widget.reply.likes;
    liked = widget.reply.likedByUser;
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeReply(context);
  }

  Widget makeReply(BuildContext _context) {
    return GestureDetector(
      onLongPress: () {
      },
        child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.01,
          top: MediaQuery.of(context).size.width * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 3.0),
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundImage: NetworkImage(defaultServerURL +widget.reply.profileImage),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        makeReplyText(),
                        Storage.getUserType == UserTypeEnum.administrator.toString() ? makeDeleteButton(_context) : Container()
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

  Widget makeDeleteButton(BuildContext _context){
    return Material(
      child: InkWell(
        onTap: () async {

          var res = await showDialog(
            context: context,
            builder: (context){
              return DeleteAlertDialog("Da li ste sigurni da želite da obrišete ovaj odgovor?");
            }
          );

          if(res)
          {
            showDialog(
              context: _context,
              builder: (context){
                return LoadingDialog("Brisanje komentara...");
              }
            );

            await CommentAPIServices.deleteComment(widget.reply.id, widget.reply.postID);
            Navigator.pop(_context);
            widget._refreshRepliesOnDelete(widget.reply.id, widget.reply.postID);
          }
        },
        child: Icon(
          MaterialCommunityIcons.close,
          size: MediaQuery.of(context).size.width * 0.008,
          color: Colors.black,
        ),
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
        likes > 0 ? GestureDetector(
          child: Text(
            likes.toString() +" sviđanja",
            style: liked == true? textStyleBold : textStyle
          ),
          onTap: (){
          },
        ) : Container(),
      ],
    );
  }

  Widget makeReplyText()
  {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.001, horizontal: MediaQuery.of(context).size.width * 0.002),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0)
      ),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.77,),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.14,
        child: RichText(
          softWrap: true,
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: widget.reply.fullName +" ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.008)),
              TextSpan(text: widget.reply.text, style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.008)),
            ]
          ),
        ),
      ),
    );
  }
}