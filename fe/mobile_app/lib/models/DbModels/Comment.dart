class Comment
{
  int _id;
  int _postID;
  int _userEntityID;
  String _text;
  int _parrentID;
  DateTime _date;
  double _latitude;
  double _longitude;

  Comment.withOutID(this._postID, this._userEntityID, this._text, this._parrentID, this._date, this._latitude, this._longitude);

  int get id => _id;
  int get postID => _postID;
  int get userEntityID => _userEntityID;
  String get text => _text;
  int get parrentID => _parrentID;
  DateTime get date => _date;
  double get latitude => _latitude;
  double get longitude => _longitude;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();
    
    if(id != null)
      data["id"] = this._id;
    data["postID"] = this._postID;
    data["userEntityID"] = this._userEntityID;
    data["text"] = this._text;
    data["parrentID"] = this._parrentID;
    data["date"] = this._date.toIso8601String();
    data["latitude"] = this._latitude;
    data["longitude"] = this._longitude;

    return data;
  }

  Comment.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._postID = data["postID"];
    this._userEntityID = data["userEntityID"];
    this._text = data["text"];
    this._parrentID = data["parrentID"];
    this._date = DateTime.parse(data["date"]);
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
  }
}