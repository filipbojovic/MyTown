class AppReply
{
  int _id;
  int _postID;
  int _parrentID;
  int _userID;
  String _firstName;
  String _lastName;
  DateTime _date;
  int _likes;
  String _text;
  String _profileImage;
  bool _likedByUser;
  int _userTypeID;

  AppReply(this._id, this._postID, this._parrentID, this._userID, this._firstName, this._lastName, this._date, this._likes, this._text, this._profileImage, this._likedByUser, this._userTypeID);
  
  int get postID => _postID;
  int get id => _id;
  int get parrentID => _parrentID;
  int get userID => _userID;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => _firstName +" " +lastName;
  DateTime get date => _date;
  int get likes => _likes;
  String get text => _text;
  String get profileImage => _profileImage;
  bool get likedByUser => _likedByUser;
  int get userTypeID => _userTypeID;

  set setLikedByUser(bool value) => _likedByUser = value;
  set setLikes(int value) => _likes = value;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["postID"] = this._postID;
    data["id"] = this._id;
    data["parrentID"] = this._parrentID;
    data["userID"] = this._userID;
    data["firstName"] = this._firstName;
    data["lastName"] = this._lastName;
    data["date"] = this._date.toIso8601String();
    data["likes"] = this._likes;
    data["text"] = this._text;
    data["profileImage"] = this._profileImage;
    data["likedByUser"] = this._likedByUser;
    data["userTypeID"] = this._userTypeID;

    return data;
  }

  AppReply.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._postID = data["postID"];
    this._parrentID = data["parrentID"];
    this._userID = data["userID"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];
    this._date = DateTime.parse(data["date"]);
    this._likes = data["likes"];
    this._text = data["text"];
    this._profileImage = data["profileImage"];
    this._likedByUser = data["likedByUser"];
    this._userTypeID = data["userTypeID"];
  }
}