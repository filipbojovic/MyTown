import 'package:bot_fe/models/AppModels/AppReply.dart';

class AppProposal
{
  int _id;
  int _postID;
  int _userID;
  String _firstName;
  String _lastName;
  DateTime _date;
  int _likes;
  String _text;
  List<String> _images;
  List<AppReply> _replies;
  String _profileImage;
  int _likeValue;
  double _latitude;
  double _longitude;
  int _userTypeID;

  AppProposal(this._id, this._postID, this._userID, this._firstName, this._lastName, this._date, this._likes, this._text, this._images, this._replies, this._profileImage, this._likeValue, this._latitude, this._longitude, this._userTypeID);
  
  int get id => _id;
  int get postID => _postID;
  int get userID => _userID;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => _firstName +" " +_lastName;
  DateTime get date => _date;
  int get likes => _likes;
  String get text => _text;
  List<String> get images => _images;
  List<AppReply> get replies => _replies;
  String get profileImage => _profileImage;
  int get likeValue => _likeValue;
  double get latitude => _latitude;
  double get longitude => _longitude;
  int get userTypeID => _userTypeID;

  set setLikes(int value) => this._likes = value;
  set setLikeValue(int value) => this._likeValue = value;
  set setText(String value) => this._text = value;
  
  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["id"] = this._id;
    data["postID"] = this._postID;
    data["userID"] = this._userID;
    data["firstName"] = this._firstName;
    data["lastName"] = this._lastName;
    data["date"] = this._date.toIso8601String();
    data["likes"] = this._likes;
    data["text"] = this._text;
    data["images"] = this._images;
    data["replies"] = this._replies;
    data["profileImage"] = this._profileImage;
    data["likeValue"] = this._likeValue;
    data["latitude"] = this.latitude;
    data["longitude"] = this.longitude;
    data["userTypeID"] = this.userTypeID;

    return data;
  }

  AppProposal.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._postID = data["postID"];
    this._userID = data["userID"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];
    this._date = DateTime.parse(data["date"]);
    this._likes = data["likes"];
    this._text = data["text"];

    List<String> imgs = new List<String>();
    for (var img in data["images"]) 
      imgs.add(img["path"]);
    this._images = imgs;

    if(data["replies"].length > 0)
    {
      List<AppReply> replies = new List<AppReply>();
      for (var reply in data["replies"]) 
        replies.add(AppReply.fromObject(reply));
      this._replies = replies;
    }
    else
      this._replies = new List<AppReply>();

    this._profileImage = data["profileImage"];
    this._likeValue = data["likeValue"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
    this._userTypeID = data["userTypeID"];
  }
}