import 'dart:convert';

import 'package:web_app/models/AppModels/AppPost.dart';

class AppReport
{
  int _id;
  int _commentID;
  int _postID;
  int _reportedUserID;
  int _senderID;
  DateTime _date;
  String _text;
  bool _read;
  String _senderFullName;
  String _reportedUserFullName;
  String _commentText;
  AppPost _post;

  AppReport(this._commentID, this._postID, this._reportedUserID, this._senderID, this._date, this._text, this._read, this._senderFullName, this._reportedUserFullName, this._commentText, this._post);

  int get id => _id;
  int get commentID => _commentID;
  int get postID => _postID;
  int get reportedUserID => _reportedUserID;
  int get senderID => _senderID;
  DateTime get date => _date;
  String get text => _text;
  bool get read => _read;
  String get senderFullName => _senderFullName;
  String get reportedUserFullName => _reportedUserFullName;
  String get commentText => _commentText;
  AppPost get appPost => _post;

  set setRead(bool value) => _read = value;

  
  AppReport.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._commentID = data["commentID"];
    this._postID = data["postID"];
    this._reportedUserID = data["reportedUserID"];
    this._senderID = data["senderID"];
    this._date = DateTime.parse(data["date"]);
    this._text = data["text"];
    this._read = data["read"];
    this._senderFullName = data["senderFullName"];
    this._reportedUserFullName = data["reportedUserFullName"];
    this._commentText = data["commentText"];
    if(data["post"]!=null)
      this._post = AppPost.fromObject(data["post"]);
    
  }
}