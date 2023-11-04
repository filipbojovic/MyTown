import 'dart:async';
import 'package:bot_fe/components/PostComponents/UserPostComponent.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:bot_fe/ui/sub_pages/UserCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/components/PostComponents/ChallengePostComponent.dart';

class PostAndCommentScreen extends StatefulWidget {
  final int postID;
  PostAndCommentScreen(this.postID);
  @override
  _PostAndCommentScreenState createState() => _PostAndCommentScreenState();
}

class _PostAndCommentScreenState extends State<PostAndCommentScreen>{
  TextEditingController commentController;
  Future _postFuture;

  _loadPost() async
  {
    return await ChallengeAPIServices.getAppPostByID(widget.postID, int.parse(loggedUserID));
  }

  _rebuild()
  {
    setState(() => null);
  }

  @override
  void initState() {
    commentController = new TextEditingController();
    _postFuture = _loadPost();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _postFuture,
      builder: (context, postSnapshot){
        if(!postSnapshot.hasData)
          return BOTFunction.loadingIndicator();
        else 
        {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.05), 
              child: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black
                ),
              )
            ),
            body: WillPopScope(
              onWillPop: (){
                var data = new Map<String, dynamic>();
                data["likes"] = postSnapshot.data.likes;
                data["comments"] = postSnapshot.data.comments;
                if(postSnapshot.data.typeID == PostTypeEnum.challengePost)
                  data["solvedByTheUser"] = postSnapshot.data.solvedByTheUser;
                Navigator.pop(context, data);
                return new Future(() => false);
              },
              child: makeBody(postSnapshot.data)
            )
          );
        }
      },
    );
  }

  Widget makeBody(AppPost post){
    return SingleChildScrollView(
      child: Column(
        children: [
          post.typeID == PostTypeEnum.challengePost ? ChallengePostComponent(false, null, null, post) : UserPostComponent(false, null, post, null),
          UserCommentScreen(post, false, _rebuild)
        ],
      ),
    );
  }
}
