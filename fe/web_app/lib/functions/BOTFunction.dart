import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_app/models/AppModels/AppUser.dart';

class NotificationTypeEnum
{
  static int postLike = 1;
  static int commentLike = 2;
  static int newComment = 3;
  static int commentReply = 4;
  static int newProposal = 5;
  static int addedProposal = 6;
}

class ReportTypeEnum
{
  static int postReport = 1;
  static int commentReport = 2;
}

class ChallengeStatusEnum
{
  static int gaveUp = -1;
  static int notSolvedYet = 0;
  static int solved = 1;
}

class UserTypeEnum
{
  static const int user = 1;
  static const int administrator = 2;
  static const int institution = 3;
}

class PostTypeEnum
{
  static const int challengePost = 1;
  static const int userPost = 2;
  static const int institutionPost = 3;
}

class BOTFunction
{
  static String getTimeDifference(DateTime date)
  {
    DateTime now = DateTime.now();
    var difference = now.difference(date);

    if(difference.inSeconds < 2)
      return "pre 1 sekunde";
    else if(difference.inSeconds < 60)
      return "pre " +difference.inSeconds.toString() +" sekundi";
    else if(difference.inMinutes == 1)
      return "pre " +difference.inMinutes.toString() +" minut";
    else if(difference.inMinutes < 60)
      return "pre " +difference.inMinutes.toString() +" minuta";
    else if(difference.inHours == 1)
      return "pre " +difference.inHours.toString() +" sat";
    else if(difference.inHours < 5)
      return "pre " +difference.inHours.toString() +" sata";
    else if(difference.inHours < 24)
      return "pre " +difference.inHours.toString() +" sati";
    else if(difference.inDays == 1)
      return "juče";
    else
      return "pre " +difference.inDays.toString() +" dana";
  }

  static String getReplyTimeDifference(DateTime date)
  {
    DateTime now = DateTime.now();
    var difference = now.difference(date);

    if(difference.inSeconds < 2)
      return "1s";
    else if(difference.inSeconds < 60)
      return difference.inSeconds.toString() +"s";
    else if(difference.inMinutes < 60)
      return difference.inMinutes.toString() +"m";
    else if(difference.inHours < 24)
      return difference.inHours.toString() +"č";
    else
      return difference.inDays.toString() +"d";
  }

  static String getChallengeRemainingTime(DateTime date)
  {
    DateTime now = DateTime.now();

    var difference = date.difference(now);

    int days = difference.inDays % 30;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    if(days > 0)
      return "${days}d : $hoursč : ${minutes}m";
    else if(hours > 0)
      return "$hours č : $minutes m";
    else if(minutes > 0)
      return "$minutes m";
    else
      return "$seconds s";
  }

  static void showSnackBar(String text, GlobalKey<ScaffoldState> _scaffoldKey)
  {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(text),
        duration: new Duration(seconds: 2)
      )
    );
  }

  static String formatDate(DateTime date)
  {
    String formatedDate;

    formatedDate = date.day.toString() +". ";

    switch (date.month) 
    {
      case 1: formatedDate += "januara "; break; case 7: formatedDate += "jula "; break;
      case 2: formatedDate += "februara "; break; case 8: formatedDate += "avgusta "; break;
      case 3: formatedDate += "marta "; break; case 9: formatedDate += "septembra "; break;
      case 4: formatedDate += "aprila "; break; case 10: formatedDate += "oktobra "; break;
      case 5: formatedDate += "maja "; break; case 11: formatedDate += "novembra "; break;
      case 6: formatedDate += "juna "; break; case 12: formatedDate += "decembra "; break;
      default: formatedDate += ""; break;
    }

    formatedDate += date.year.toString() +". godine";
    return formatedDate;
  }

  static String formatDateDayMonthYear(DateTime date){
    return DateFormat('dd.MM.yyyy.').format(date);
  }

  static Widget loadingIndicator()
  {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.black87,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
}