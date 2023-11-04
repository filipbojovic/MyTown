import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Comments/RepliesComponent.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Post/CommentScreen.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppProposal.dart';
import 'package:web_app/models/AppModels/AppReply.dart';
import 'package:web_app/services/storage.services.dart';

import '../../services/api/comment.api.dart';

class UserReplyController
{
  void Function(AppReply newReply) refreshRepliesOnAdd;
}

class UserCommentComponent extends StatefulWidget {
  final AppProposal proposal;
  final UserCommentController commentController;
  UserCommentComponent(this.proposal, this.commentController, {Key key}) : super(key: key);

  @override
  _UserCommentComponentState createState() => _UserCommentComponentState();
}

class _UserCommentComponentState extends State<UserCommentComponent> with AutomaticKeepAliveClientMixin {
  Image image;
  final UserReplyController _replyController = new UserReplyController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeProposal(context);
  }

  Widget makeProposal(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.003,
        vertical: MediaQuery.of(context).size.width * 0.002,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center ,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(defaultServerURL +widget.proposal.profileImage),
                      radius: MediaQuery.of(context).size.width * 0.013,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.002),
                    makeTimeAndFullName(context),
                  ],
                ),
                Storage.getUserType == UserTypeEnum.administrator.toString() ? makeDeleteButton(context) : Container()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                makeCommentText(),
                if(widget.proposal.images.length > 0)
                  makeImageView(widget.proposal.images),
              ],
            ),
            RepliesComponent(widget.commentController, _replyController, widget.proposal.replies, key: UniqueKey(),)
          ],
        ),
    );
  }

  Material makeDeleteButton(BuildContext _context) {
    return Material(
      child: InkWell(
        enableFeedback: false,
        onTap: () async {
          
          var res = await showDialog(
            context: context,
            builder: (context){
              return DeleteAlertDialog("Da li ste sigurni da želite da obrišete ovaj komentar?");
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

            await CommentAPIServices.deleteComment(widget.proposal.id, widget.proposal.postID);
            Navigator.pop(_context);
            widget.commentController.refreshCommentOnDelete(widget.proposal.id, widget.proposal.postID);
          }
        },
        child: Icon(
          MaterialCommunityIcons.close,
          size: MediaQuery.of(context).size.width * 0.009,
          color: Colors.black,
        )
      ),
    );
  }

  Column makeTimeAndFullName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.proposal.fullName,
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.009
          ),
        ),
        Text(
          BOTFunction.getTimeDifference(widget.proposal.date),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.008
          ),
        )
      ],
    );
  }

  Widget makeCommentText()
  {
    return Stack(
      children: [
        makeText(),
        if(widget.proposal.likes > 0) 
          makeSmallLikeCount()
      ],
    );
  }

  Container makeText() {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.005,
        bottom: MediaQuery.of(context).size.width * 0.001,
        top: MediaQuery.of(context).size.width * 0.002
      ),
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.002,
        horizontal: MediaQuery.of(context).size.width * 0.003
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.proposal.text,
            softWrap: true,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.009,
              color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
  Positioned makeSmallLikeCount() {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      child: GestureDetector(
        onTap: (){
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 1.0, // has the effect of softening the shadow
                spreadRadius: 1.0, // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.008,
                  minHeight: MediaQuery.of(context).size.width * 0.008,
                ),
                child: Icon(
                  Icons.thumb_up, 
                  size: MediaQuery.of(context).size.width * 0.0055,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.005,),
              Text(widget.proposal.likes.toString())
            ],
          ),
        ),
      )
    );
  }

  Widget makeImageView(List<String> images) //display for images in the proposal
  {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){},
            child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.003,
                  horizontal: MediaQuery.of(context).size.width * 0.003,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(defaultServerURL +images[index]),
                  )
                ),
                //height: MediaQuery.of(context).size.height * 0.03,
                width: MediaQuery.of(context).size.width * 0.06,
                child: Container()
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