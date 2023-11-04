import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/ViewModels/TopUser.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:flutter/material.dart';

class RankListDialog extends StatefulWidget {

  @override
  _RankListDialogState createState() => _RankListDialogState();
}

class _RankListDialogState extends State<RankListDialog> {
  Future userFuture;

  _loadTop10Users() async
  {
    return await UserAPIServices.getTop10Users();
  }

  @override
  void initState() {
    userFuture = _loadTop10Users();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userFuture,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return BOTFunction.loadingIndicator();
        else
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: themeColor,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01,
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var item in snapshot.data)
                      makeOneUserView(context, item),
                  ],
                ),
              ),
            ),
          );
      },

    );
  }

  Widget makeOneUserView(BuildContext context, TopUser user)
  {
    return Card(
      elevation: 5.0,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.007,
          vertical: MediaQuery.of(context).size.width * 0.003,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.width * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            makeFullNameAndAvatar(context, user),
            makePointsLabel(context, user),
          ],
        ),
      ),
    );
  }

  Text makePointsLabel(BuildContext context, TopUser user) {
    var lastNumber = user.points.toString().substring(user.points.toString().length - 1);
    return Text(
      user.points.toString() + (lastNumber == "1" ? " poen" : " poena"),
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.045,
      )
    );
  }

  Row makeFullNameAndAvatar(BuildContext context, TopUser user) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            defaultServerURL +user.photoURL
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
        Text(
          user.fullName,
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.045
          ),
        ),
      ],
    );
  }
}