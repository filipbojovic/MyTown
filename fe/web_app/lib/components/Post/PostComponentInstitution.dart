import 'dart:html';
import 'package:flutter/material.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Other/imageSliderComponent.dart';
import 'package:web_app/components/Post/AddProposalPopUp.dart';
import 'package:web_app/components/Post/CommentScreen.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';

import '../../services/api/post.api.dart';

class PostComponentInstitution extends StatefulWidget {

  final AppPost post;
  final Function refreshPosts;

  PostComponentInstitution(this.post, this.refreshPosts, {Key key}) : super(key: key);

  @override
  _PostComponentInstitutionState createState() => _PostComponentInstitutionState(post);
}

class _PostComponentInstitutionState extends State<PostComponentInstitution> {

  final AppPost post;
  _PostComponentInstitutionState(this.post);

  String address = '';

  _changeSolveStatus()
  {
    setState(() {
      widget.post.setSolvedByTheUser = ChallengeStatusEnum.solved;
      widget.post.setCommentCount = 1;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[400])
      ),
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.0024,
        horizontal: MediaQuery.of(context).size.width * 0.175
      ),
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.0028),
      width: MediaQuery.of(context).size.width * 0.3,
      //height: MediaQuery.of(context).size.height * 0.665,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            //represents each row in post
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              makeHeader(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.007),
              if(post.title != null) makeTitle(),
              if(post.title != null) SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              if(widget.post.imageURLS.length > 0) 
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[400]))
                ),
                child: ImageSliderComponent(post.imageURLS)
              ),
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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.005,
        vertical: MediaQuery.of(context).size.width * 0.005,
      ),
      child: Row(
        children: <Widget>[
          makeLikeCount(true),
          makeLike(true),
          SizedBox(width: MediaQuery.of(context).size.width * 0.005),
          makeLikeCount(false),
          makeLike(false),
          SizedBox(width: MediaQuery.of(context).size.width * 0.005),
          if(post.typeID == PostTypeEnum.challengePost)
            makeSolveButton(),
        ],
      ),
    );
  }

  Widget makeSolveButton(){
    return widget.post.solvedByTheUser == ChallengeStatusEnum.notSolvedYet ?
    Material(
      color: Colors.green,
      borderRadius: BorderRadius.circular(7.0),
      child: InkWell(
        hoverColor: hoverColor,
        splashColor: splashColor,
        enableFeedback: false,
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            child: AddProposalPopUP(_changeSolveStatus, widget.post)
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.002,
            vertical: MediaQuery.of(context).size.width * 0.001,
          ),
          child: Text(
            'Postavite rešenje',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.009
            ),
          ),
        ),
      ),
    ) :
    Text(
      'Postavili ste rešenje izazova.',
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.009,
        fontWeight: FontWeight.bold
      ),
    );
  }

  

  Widget makeTitle() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.005),
      child: Text(post.title,
        style: TextStyle(
          color: Colors.grey[900],
          fontSize: 22.0,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }

  Widget makeHeader(BuildContext _context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.005),
      child: Row(
        // a row which contains: the row with picture and username/date | iconButton
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            //a row which contains a picture | column with username/date
            children: <Widget>[
              makeProfilePhoto(),
              SizedBox(width: MediaQuery.of(context).size.width * 0.002),
              makeUserNameAndTime(),
            ],
          ),
          // if(widget.post.userEntityID == loggedUser.id) Material(
          //   child: InkWell(
          //     borderRadius: BorderRadius.circular(30.0),
          //     onTap: (){
          //       return makePopUpMenu();
          //     },
          //     hoverColor: themeColor,
          //     child: Icon(Icons.more_horiz)
          //   ),
          // )
          if(widget.post.userEntityID == loggedUser.id)
            makePopUpMenu(_context),
        ],
      ),
    );
  }

  Widget makePopUpMenu(BuildContext _context)
  {
    return PopupMenuButton<int>(

      elevation: 5.0,
      tooltip: "Opcije",
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          height: MediaQuery.of(context).size.height * 0.01,
          child: Text(
            "Obriši",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.009
            ),
          ),
        )
      ],
      onSelected: (value) async {
        showDialog(
          context: _context,
          builder: (context){
            return LoadingDialog("Brisanje objave...");
          }
        );
        await PostAPIServices.deletePost(widget.post.id);
        widget.refreshPosts(widget.post);
        Navigator.pop(_context);
      },
    );
  }

  Column makeUserNameAndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(post.fullName,
          style: TextStyle(
            color: post.institution ? Colors.orange[900] : Colors.grey[900],
            fontSize: MediaQuery.of(context).size.width * 0.01,
            fontWeight: FontWeight.bold
          )
        ),
        SizedBox(
          height: 3.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: makeTimeAndLocation()
        ),
      ],
    );
  }

  Container makeProfilePhoto() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.03,
      height: MediaQuery.of(context).size.width * 0.03,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[400]),
          image: DecorationImage(
              image: NetworkImage(defaultServerURL +
                  post.userProfilePhotoURL),
              fit: BoxFit.cover)),
    );
  }

  Widget makeDescriptionField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.005,
        vertical: MediaQuery.of(context).size.width * 0.003,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: RichText(
          text: TextSpan(
            text: post.description,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.0095,
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

  Widget makeLikeCount(bool likes) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          //'100k',
          likes ?  post.likes.toString() : post.comments.toString(),
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.009,
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
          horizontal: MediaQuery.of(context).size.width * 0.002
        ),
      ),
    );
  }

  Widget makeLike(bool likes) {
    return Material(
      child: InkWell(
        enableFeedback: false,
        splashColor: Colors.transparent,
        onTap: (){
          if(widget.post.comments > 0) showDialog(
            context: context,
            child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.005,
                horizontal: MediaQuery.of(context).size.height * 0.007,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentScreen(post),
                    ],
                  ),
                ],
              ),
            )
          )
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.height * 0.03,
          height: MediaQuery.of(context).size.height * 0.03,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white)
          ),
          child: Center(
            child: Icon(
              likes ? Icons.thumb_up : Icons.message,
              size: MediaQuery.of(context).size.height * 0.02,
              color: Colors.white,
            ),
          ),
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