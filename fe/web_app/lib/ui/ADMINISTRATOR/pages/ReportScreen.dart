import 'dart:async';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Post/PostAndCommentPopUp.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/models/AppModels/AppReport.dart';
import 'package:web_app/services/api/comment.api.dart';
import 'package:web_app/services/api/post.api.dart';
import 'package:web_app/services/api/report.api.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {

  StreamController _reportStream;
  List<AppReport> _fullList;

  _getReport() async 
  {
    await ReportAPIServices.getAllAppReports().then((value){
      _reportStream.add(value);
      _fullList = value;
    });
  }

  _removeReport(AppReport report)
  {
    if(report.commentID == null)
      _fullList.removeWhere((element) => element.postID == report.postID);
    else
      _fullList.removeWhere((element) => element.postID == report.postID && element.commentID == report.commentID);
      
    _reportStream.add(_fullList);
  }

  @override
  void initState() {
    _reportStream = new StreamController();
    _getReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _reportStream.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return BOTFunction.loadingIndicator();
        else 
        {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.006),
            child: Container(
              child: Column(
                children: [
                  createCounterCards(snapshot.data),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.020),
                  Expanded(child: makeReportBoxes(snapshot.data))
                ],
              )
            ),
          );
        }
      }
    );
  }

  Widget createCounterCards(List<AppReport> reports) {
    int todayNumber = 0;
    for (var item in reports)
      if (checkDate(item.date)) 
        todayNumber++;

    int sumReports = reports.length;
    int notReadReports =
        reports.where((element) => element.read == false).length;

    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            makeCounterBox(2, todayNumber),
            makeCounterBox(3, notReadReports),
            makeCounterBox(1, sumReports)
          ],
        )
    );
  }

  bool checkDate(DateTime date) {
    DateTime today = DateTime.now();
    int date1 = date.day + date.month * 12 + date.year * 365;
    int date2 = today.day + today.month * 12 + today.year * 365;
    return date1 == date2;
  }

  Widget makeCounterBox(int ind, int number) {
    IconData icon;
    String text;

    if (ind == 1) {
      icon = OMIcons.announcement;
      text = 'Ukupan broj prijava';
    } else if (ind == 2) {
      icon = Icons.calendar_today;
      text = 'Broj prijavljeno danas';
    } else {
      icon = Icons.folder_open;
      text = 'Broj neprocitanih prijava';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: themeColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.007,
        vertical: MediaQuery.of(context).size.height * 0.01
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          makeCounterBoxLabel(text),
          makeCounterBoxIcon(icon, number),
        ],
      ),
    );
  }

  Row makeCounterBoxIcon(IconData icon, int number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          icon,
          size: MediaQuery.of(context).size.width * 0.015,
          color: Colors.black,
        ),
        Text(
          '$number',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.019,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Container makeCounterBoxLabel(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.011,
              color: Colors.black,
            ),
          )
        ],
      )
    );
  }

  Widget makeReportBoxes(List<AppReport> reports) {
    var postReports = reports
      .where((element) => element.commentID == null)
      .toList();
    var commentReports = reports
      .where((element) => element.commentID != null)
      .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: themeColor,
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          child: makePostReportBox(postReports),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: themeColor,
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          child: makeCommentReportBox(commentReports),
        ),
      ]
    );
  }

  Widget makePostReportBox(List<AppReport> reports) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.003,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Prijavljene objave',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.015,
              fontWeight: FontWeight.w500
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.0035),
          Expanded(child: makePostReportList(reports)),
        ],
      ),
    );
  }

  Widget makePostReportList(List<AppReport> reports) {
    return Container(
      color: themeColor,
      child: reports.isEmpty ? 
        Center(child: Text('Nema prijavljenih objava')) :
        ListView.builder(
          shrinkWrap: true,
          itemCount: reports.length,
          itemBuilder: (context, index) {
            return makeReportCard(reports[index]);
          },
        ),
    );
  }

  Widget makeCommentReportBox(List<AppReport> reports) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.003,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Prijavljeni komentari',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.015,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.0035),
          Expanded(child: makeCommentReportList(reports)),
        ],
      ),
    );
  }

  Widget makeCommentReportList(List<AppReport> reports) {
    return Container(
      color: themeColor,
      child: reports.isEmpty ?
        Center(child: Text('Nema prijavljenih komentara')) : 
        ListView.builder(
          shrinkWrap: true,
          itemCount: reports.length,
          itemBuilder: (context, index) {
            return makeReportCard(reports[index]);
        },
      ),
    );
  }

  Widget makeReportCard(AppReport report) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ListTile(
        dense: true,
        title: makeTitleLabel(report),
        subtitle: makeReportDescription(report),
        isThreeLine: true,
      ),
    );
  }

  Container makeReportDescription(AppReport report) {
    return Container(
      padding:
        EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.005
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          makeFirstLabelInReportDescription(report),
          makeSecondLabelInReportDescription(report),
          if(report.commentID != null)
            makeCommentTextLabel(report),
          SizedBox(height: MediaQuery.of(context).size.width * 0.005),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              makeDateLabel(report),
              createReportButtons(report, report.appPost)
            ],
          ),
        ],
      ),
    );
  }

  Text makeDateLabel(AppReport report) {
    return Text(
      BOTFunction.getTimeDifference(report.date),
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.010,
        color: Colors.black
      ),
    );
  }

  Text makeSecondLabelInReportDescription(AppReport report) {
    return Text(
      'Dodatni komentar : ${report.text}',
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.010,
        color: Colors.black
      ),
    );
  }

  Text makeFirstLabelInReportDescription(AppReport report) {
    return Text(
      'Korisnik ${report.senderFullName} je prijavio/la objavu korisnika ${report.reportedUserFullName}.',
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.010,
        color: Colors.black
      ),
    );
  }

  Widget makeTitleLabel(AppReport report) {
    return Text(
      '${report.appPost.title != null ? report.appPost.title : 'Bez naslova'}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.011,
        color: Colors.black
      ),
    );
  }

  Text makeCommentTextLabel(AppReport report) {
    return Text(
      'Prijavljen komentar : ${report.commentText}',
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.010,
        color: Colors.black
      ),
    );
  }

 //-----------------------REPORT BUTTONS-----------------------------------------------------
 //------------------------------------------------------------------------------------------
  Widget createReportButtons(AppReport report, AppPost post) 
  {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          report.read ? 
            makeTick() :
            makeMarkAsReadButton(report),
          SizedBox(width: MediaQuery.of(context).size.width * 0.003),
          makeShowPostButton(post),
          SizedBox(width: MediaQuery.of(context).size.width * 0.003),
          makeDeleteButton(report)
        ]
      )
    );
  }

  Material makeShowPostButton(AppPost post) {
    return Material(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.003,
            horizontal: MediaQuery.of(context).size.width * 0.002
          ),
          child: Text(
            'Pogledaj\nobjavu',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.008,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PostAndCommentPopUp(post);
            }
          );
        }
      ),
    );
  }

  Material makeDeleteButton(AppReport report) 
  {
    return Material(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.003,
            horizontal: MediaQuery.of(context).size.width * 0.002
          ),
          child: Text(
            report.commentID != null ? 'Obriši\nkomentar' : 'Obriši\nobjavu',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.008,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () async {
          var res = await showDialog(
            context: context,
            child: DeleteAlertDialog('Da li ste sigurni da želite da obrišete ' +(report.commentID == null ? "ovu objavu?" : "ovaj komentar?")),
          );

          if(!res)
            return;

          showDialog(
            context: context,
            builder: (context){
              return LoadingDialog("Brisanje " +(report.commentID != null ? "komentara..." : "objave..."));
            }
          );

          if(report.commentID == null)
            await PostAPIServices.deletePost(report.postID);
          else
            await CommentAPIServices.deleteComment(report.commentID, report.postID);
          
          _removeReport(report);
          Navigator.pop(context);
        }
      ),
    );
  }

  Widget makeMarkAsReadButton(AppReport report) {
    return Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.003,
            horizontal: MediaQuery.of(context).size.width * 0.002
          ),
          child: Text(
            'Označi kao\npročitano',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.008,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () async {
          report.commentID != null ?
            await ReportAPIServices.markCommentReportAsRead(report.id).then((value){
              setState(() => report.setRead = true);
            }) :
            await ReportAPIServices.markPostReportAsRead(report.id).then((value){
              setState(() => report.setRead = true);
            });
        },
      ),
    );
  }

  Widget makeTick() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.003,
        horizontal: MediaQuery.of(context).size.width * 0.002
      ),
      child: Icon(Icons.check, color: Colors.green),
    );
  }
}
