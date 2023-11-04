import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_app/components/Tiles/TilePostComponent.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/services/api/post.api.dart';
import 'package:web_app/ui/ADMINISTRATOR/pages/PostScreen.dart';

class ChallengePostView extends StatefulWidget {
  final BuildContext ctx;
  final FilterController fc;
  ChallengePostView(this.ctx, this.fc);
  @override
  _ChallengePostViewState createState() => _ChallengePostViewState();
}

class _ChallengePostViewState extends State<ChallengePostView> {

  StreamController _postStreamController;
  List<AppPost> _fullList = new List<AppPost>();

  _loadPosts() async
  {
    PostAPIServices.getFilteredPostsAdminPage("", -1, PostTypeEnum.challengePost).then((value){
      _postStreamController.add(value);
      _fullList = value;
    });
  }

  _filterPosts(String filterText, int cityID, int postType)
  {
    PostAPIServices.getFilteredPostsAdminPage(filterText, cityID, postType).then((value){
      _fullList = value;
      _postStreamController.add(value);
    });
  }

  _deleteChallenge(AppPost post)
  {
    _fullList.remove(post);
    _postStreamController.add(_fullList);
  }

  @override
  void initState() {
    widget.fc.filterPosts = _filterPosts;
    _postStreamController = new StreamController();
    _loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _postStreamController.stream,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return BOTFunction.loadingIndicator();
        else
          return makeBody(snapshot.data);
      },
    );
  }

  Widget makeBody(List<AppPost> posts)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.001),
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        itemCount: posts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.0013,
          mainAxisSpacing: MediaQuery.of(context).size.height * 0.003,
          childAspectRatio: 4
        ),
        itemBuilder: (context, index) {
          return TilePostComponent(widget.ctx, posts[index], _deleteChallenge, key: UniqueKey(),);
        }
      )
    );
  }
}