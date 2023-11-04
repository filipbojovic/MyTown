import 'dart:async';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppAcceptedChallenge.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:bot_fe/ui/sub_pages/PostAndCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';


class AcceptedChallengeTileComponent extends StatefulWidget {

  final AppAcceptedChallenge post;
  AcceptedChallengeTileComponent(this.post);
  @override
  _AcceptedChallengeTileComponentState createState() => _AcceptedChallengeTileComponentState(post);
}

class _AcceptedChallengeTileComponentState extends State<AcceptedChallengeTileComponent> {

  final AppAcceptedChallenge post;
  _AcceptedChallengeTileComponentState(this.post);

  StreamController _timerStreamController;
  Stream _stream;
  Timer _timer;

  _startTimer()
  {
    _timer = Timer.periodic(Duration(seconds: 1), (timer)
     {
       if(DateTime.now().isBefore(post.endDate))
          _timerStreamController.add(BOTFunction.getChallengeRemainingTime(post.endDate));
        else
        {
          timer.cancel();
          setState(() {
            timer = null;
          });
        }
     }
    );
  }

  _setStream()
  {
    _timerStreamController = new StreamController.broadcast();
    _stream = _timerStreamController.stream;
  }

  @override
  void initState() {
    super.initState();
    _setStream();
    if(DateTime.now().isBefore(post.endDate))
      _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timerStreamController.close();
    if(_timer != null)
      _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          makeTitle(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              makePhoto(context),
              Expanded(child: makeDetails()),
            ],
          )
        ],
      ),
    );
  }

  Container makePhoto(BuildContext context) {
    return Container(
      child: GFAvatar(
        backgroundImage: NetworkImage(defaultServerURL +widget.post.image),
        shape: GFAvatarShape.standard,
        size: MediaQuery.of(context).size.width * 0.17,
      ),
    );
  }

  Text makeTitle(){
    return Text(
      widget.post.title.length > 30 ? widget.post.title.substring(0, 30) +"..." : widget.post.title,
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.w500
      ),
    );
  }

  Widget makeDetails()
  {
    return Column(
      children: [
        if(DateTime.now().isBefore(post.endDate) && post.status == 0)
        StreamBuilder(
          stream: _stream,
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Text(BOTFunction.getChallengeRemainingTime(post.endDate));
            else
              return Text(snapshot.data.toString());
          },
        ),
        if(post.status == 0) DateTime.now().isBefore(post.endDate) ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            makeSolveButton(),
            makeGiveUpButton(),
          ],
        ) : 
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: <Widget>[
              Text('Još uvek niste postavili rešenje.', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 16.0),),
              SizedBox(height: 5.0,),
              makeShowChallengeButton(),
            ],
          ),
        ),
        if(post.status == -1)
          Container(
            child: Column(
              children: <Widget>[
                Text('Odustali ste od ovog izazova.', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 16.0),),
                SizedBox(height: 5.0,),
                makeShowChallengeButton(),
              ],
            ),
          ),
        if(post.status == 1)
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: <Widget>[
                Text('Postavili ste rešenje za ovaj izazov.', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 16.0),),
                SizedBox(height: 5.0,),
                makeShowChallengeButton(),
              ],
            ),
          )
      ],
    );
  }

  Widget makeGiveUpButton()
  {
    return OutlineButton(
      child: Text('Odustani'),
      onPressed: () async {
        var res = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return makeGiveUpDialog(context);
          }
        );
        if(res)
        {
          var result = await ChallengeAPIServices.giveUpTheChallenge(post.postID, post.userEntityID);
          if(result == "true")
          {
            setState(() => post.setStatus = -1);
            loggedUser.substractPoints();
          }
        }
      },
    );
  }

  Dialog makeGiveUpDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Da li ste sigurni da želite da odustanete od izazova?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.043,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text('Odustajanjem od izazova izgubićete 5 društvenih poena.'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Potvrdi', style: TextStyle(color: Colors.white)),
                ),
                RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Poništi', style: TextStyle(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Widget makeShowChallengeButton()
  {
    return OutlineButton(
      child: Text('Prikaži izazov'),
      onPressed: (){ 
        Navigator.push(context, MaterialPageRoute(builder: (_) => PostAndCommentScreen(widget.post.postID)));
      },
    );
  }

  OutlineButton makeSolveButton() {
    return OutlineButton(
      child: Text('Postavi rešenje'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PostAndCommentScreen(widget.post.postID))).then((value){
          setState(() => post.setStatus = value["solvedByTheUser"]);
        });
      },
    );
  }
}