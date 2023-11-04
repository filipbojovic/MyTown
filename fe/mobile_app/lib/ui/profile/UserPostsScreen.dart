import 'package:bot_fe/components/Tiles/ChallengeTileComponent.dart';
import 'package:bot_fe/components/Tiles/PostTileComponent.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPostsScreen extends StatefulWidget {

  final int userID;
  UserPostsScreen(this.userID);

  @override
  _UserPostsScreenState createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  Future postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = _getPostsByUserID();
  }

  _getPostsByUserID() async
  {
    return await ChallengeAPIServices.getAppPostsByUserID(widget.userID);
  }
  

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: postsFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data != null)
          {
            if(snapshot.data.length > 0)
            {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  AppPost post = snapshot.data[index];
                  switch (post.typeID) {
                    case PostTypeEnum.userPost : return UserPostComponent(snapshot.data[index]); break;
                    case PostTypeEnum.challengePost: return ChallengeTileComponent(snapshot.data[index]); break;
                    default: return Container(); break; 
                  }
                },
              );
            }
            else
              return BOTFunction.noContent("Nema objava.");
          }
          else
            return BOTFunction.loadingIndicator();
        },
      ),
    );
  }
}