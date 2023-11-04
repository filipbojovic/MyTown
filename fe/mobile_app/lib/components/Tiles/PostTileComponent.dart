import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/ui/sub_pages/PostAndCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';


class UserPostComponent extends StatefulWidget {

  final AppPost post;
  UserPostComponent(this.post);
  @override
  _UserPostComponentState createState() => _UserPostComponentState(post);
}

class _UserPostComponentState extends State<UserPostComponent> {
  final AppPost post;
  _UserPostComponentState(this.post);

  @override
  Widget build(BuildContext context) {
    return createPosts();
  }
  Widget createPosts() {
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
      child: Row(
        //mainAxisAlignment: widget.post.imageURLS.length > 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          widget.post.imageURLS.length > 0 ? Container(
            width: MediaQuery.of(context).size.width * 0.26,
            child: GFAvatar(
              backgroundImage: NetworkImage(defaultServerURL +widget.post.imageURLS[0]),
              shape: GFAvatarShape.standard,
              size: MediaQuery.of(context).size.width * 0.17,
            ),
          ) : 
          Container(
            width: MediaQuery.of(context).size.width * 0.26,
            child: GFAvatar(
              child: Center(child: Text("Bez slike")),
              shape: GFAvatarShape.standard,
              size: MediaQuery.of(context).size.width * 0.15,
              backgroundColor: Colors.black,
            ),
          ),
          SizedBox(width: 5.0),
          makeDetails(),
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
        makeShowPostButton()
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

  Widget makeShowPostButton()
  {
    return OutlineButton(
      child: Text('Prikaži objavu'),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => PostAndCommentScreen(widget.post.id))).then((value){
          setState(() {
            post.setComments = value["comments"];
            post.setLikeCount = value["likes"];
          });
        });
      },
    );
  }
}