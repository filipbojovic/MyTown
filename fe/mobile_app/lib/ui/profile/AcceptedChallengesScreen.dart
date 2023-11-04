import 'package:bot_fe/components/Tiles/AcceptedChallengeTileComponent.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AcceptedChallengesScreen extends StatefulWidget {

  final int userID;
  AcceptedChallengesScreen(this.userID);

  @override
  _AcceptedChallengesScreenState createState() => _AcceptedChallengesScreenState();
}

class _AcceptedChallengesScreenState extends State<AcceptedChallengesScreen> {
  Future acceptedChallengesFuture;

  @override
  void initState() {
    super.initState();
    acceptedChallengesFuture = _getAcceptedChallenges();
  }

  _getAcceptedChallenges() async
  {
    return await ChallengeAPIServices.getAcceptedChallengesByUser(widget.userID);
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
        future: acceptedChallengesFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data != null)
          {
            if(snapshot.data.length > 0)
            {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return AcceptedChallengeTileComponent(snapshot.data[index]);
                },
              );
            }
            else
              return BOTFunction.noContent("Niste prihvatili nijedan izazov.");
          }
          else
            return BOTFunction.loadingIndicator();
        },
      ),
    );
  }
}