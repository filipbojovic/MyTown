import 'package:flutter/material.dart';
import 'package:web_app/components/Other/imageSliderComponent.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';

class PostComponent extends StatefulWidget {

  final AppPost post;

  PostComponent(this.post);

  @override
  _PostComponentState createState() => _PostComponentState(post);
}

class _PostComponentState extends State<PostComponent> {

  final AppPost post;
  _PostComponentState(this.post);

  String address = '';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.007),
      width: MediaQuery.of(context).size.width * 0.2,
      //height: MediaQuery.of(context).size.height * 0.665,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            //represents each row in post
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              makeHeader(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.007),
              if(post.title != null) makeTitle(),
              if(post.title != null) SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              if(widget.post.imageURLS.length > 0) ImageSliderComponent(post.imageURLS),
              //if(widget.post.imageURLS.length == 1) SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              makeDescriptionField(),
              //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
          makeFooter()
        ],
      ),
    );
  }

  Container makeFooter() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Colors.grey[900], width: 0.3),
      )),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.007),
      child: Row(
        children: <Widget>[
          makeLikeCount(),
          makeLike(),
        ],
      ),
    );
  }

  Text makeTitle() {
    return Text(post.title,
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: 22.0,
        fontWeight: FontWeight.bold
      )
    );
  }

  Widget makeHeader() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.19,
      child: Row(
        // a row which contains: the row with picture and username/date | iconButton
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            //a row which contains a picture | column with username/date
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.width * 0.03,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(defaultServerURL +
                            post.userProfilePhotoURL),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.002),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(post.fullName,
                      style: TextStyle(
                          color: post.institution ? Colors.orange[900] : Colors.grey[900],
                          fontSize: MediaQuery.of(context).size.width * 0.01,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 3.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: makeTimeAndLocation()
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget makeDescriptionField() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: RichText(
          text: TextSpan(
            text: post.description,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.008,
              color: Colors.black,
            )
          ),
          softWrap: true,
        ),
      ),
    );
  }

  Widget makeTimeAndLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(BOTFunction.getTimeDifference(post.date),
            style: TextStyle(color: Colors.grey[600], fontSize: 15.0)),
        if(post.typeID == PostTypeEnum.challengePost) GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.62,
            child: Text(
              address,
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            )
          ),
        ),
      ],
    );
  }

  Widget makeLikeCount() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          //'100k',
          post.likes.toString(),
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.007,
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
          vertical: MediaQuery.of(context).size.width * 0.001,
          horizontal: MediaQuery.of(context).size.width * 0.001
        ),
      ),
    );
  }

  Widget makeLike() {
    return Container(
      width: MediaQuery.of(context).size.height * 0.02,
      height: MediaQuery.of(context).size.height * 0.02,
      decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(
          Icons.thumb_up,
          size: MediaQuery.of(context).size.height * 0.013,
          color: Colors.white,
        ),
      ),
    );
  }

  TextStyle myTextStyle() {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * 0.01
    );
  }
}
