import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/AppModels/AppUser.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:bot_fe/services/api/comment.api.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:flutter/material.dart';

class ListUsersComponent extends StatefulWidget {
  final int entityID;
  final int commentID;
  ListUsersComponent(this.entityID, this.commentID);

  @override
  _ListUsersComponentState createState() => _ListUsersComponentState();
}

class _ListUsersComponentState extends State<ListUsersComponent> {

  int entityID;
  int commentID;
  Future entityLikesListFuture;
  Future commentLikesListFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      entityID = widget.entityID;
      commentID = widget.commentID;
    });

    if(commentID == null)
      entityLikesListFuture = _getEntityLikes();
    else
      commentLikesListFuture = _getCommentLikes();
  }

  _getEntityLikes() async
  {
    return await ChallengeAPIServices.getLikesWithUserInfoByPostID(entityID);
  }

  _getCommentLikes() async
  {
    return await CommentAPIServices.getUserLikesWithUserInfoByCommentID(entityID, commentID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: commentID == null? entityLikesListFuture : commentLikesListFuture,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Container();
        else
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              )
            ),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return makeListChild(snapshot.data[index]);
              }
            ),
          );
      }
    );
  }

  Widget makeListChild(AppUser user) {
    return GestureDetector(
      child: ListTile(
        leading: makeUserView(user),
        trailing: makeRankView(user),
      ),
      onTap: (){
      },
    );
  }

  Widget makeUserView(AppUser user) {
    return GestureDetector(
      onTap: (){
        //if(user. != PostTypeEnum.institutionPost)
          Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(user.id, user.id != loggedUser.id ?  false : true)));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          makeProfilePhoto(user),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          makeFullName(user.fullName),
        ],
      ),
    );
  }

  Row makeRankView(AppUser user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: MediaQuery.of(context).size.width * 0.04,
          backgroundImage: NetworkImage(defaultServerURL +user.rankPhotoURL)
        ),
        Text(
          user.rankName,
          style: TextStyle(
            color: Colors.black
          ),
        )
      ],
    );
  }

  Widget makeFullName(String fullName)
  {
    return Text(
      fullName,
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.04
      ),
    );
  }
  CircleAvatar makeProfilePhoto(user) {
    return CircleAvatar(
      backgroundImage: NetworkImage(defaultServerURL +user.profilePhotoURL),
      radius: MediaQuery.of(context).size.width * 0.05,
    );
  }
}