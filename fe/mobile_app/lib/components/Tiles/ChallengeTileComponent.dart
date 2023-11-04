import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/ui/sub_pages/PostAndCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';


class ChallengeTileComponent extends StatefulWidget {

  //final Post post;
  final AppPost post;
  ChallengeTileComponent(this.post);
  @override
  _ChallengeTileComponentState createState() => _ChallengeTileComponentState(post);
}

class _ChallengeTileComponentState extends State<ChallengeTileComponent> {
  //final Post post;
  final AppPost post;
  _ChallengeTileComponentState(this.post);

  @override
  Widget build(BuildContext context) {
    return createChallenges();
  }
  Widget createChallenges() {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: themeColor,
            offset: Offset(1.0, 1.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              widget.post.imageURLS.length>0?
              Container(
                child: GFAvatar(
                  backgroundImage: NetworkImage(defaultServerURL +widget.post.imageURLS[0]),
                  shape: GFAvatarShape.standard,
                  size: MediaQuery.of(context).size.width * 0.17,
                ),
              ) :
              Container(
                child: GFAvatar(
                  child: Center(child: Text("Bez slike")),
                  shape: GFAvatarShape.standard,
                  size: MediaQuery.of(context).size.width * 0.17,
                  backgroundColor: Colors.black,
                ),
              ),
              SizedBox(width: 5.0),
              makeDetails(),
            ],
          )
        ],
      ),
    );
  }

  Widget makeDetails()
  {
    return Flexible(  
      child: Column(
        children: [
          makeTitleLabel(),
          makeLikeAndCommentCount(),
        ],
      )
    );
  }

  Widget makeLikeAndCommentCount()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.post.likes.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
        Icon(MaterialCommunityIcons.thumb_up_outline, color: Colors.green,),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        Text(
          widget.post.comments.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
        Icon(MaterialCommunityIcons.message_outline, color: Colors.green,),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        makeChallengeButton()
      ],
    );
  }

  Text makeTitleLabel() {
    return Text(
      widget.post.description.length > 90 ?
        widget.post.description.substring(0, 90) +"..." :
        widget.post.description,
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.04
      ),
    );
  }

  Widget makeChallengeButton()
  {
    return OutlineButton(
      child: Text('Prikaži izazov'),
      onPressed: (){ 
        Navigator.push(context, MaterialPageRoute(builder: (_) => PostAndCommentScreen(widget.post.id))).then((value){
          setState(() => post.setLikeCount = value["likes"]);
        });
      },
    );
  }
}