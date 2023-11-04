class AppAcceptedChallenge
{
  int _postID;
  int _userEntityID;
  DateTime _endDate;
  String _image;
  String _title;
  int _status;

  AppAcceptedChallenge(this._postID, this._userEntityID, this._title, this._image, this._endDate, this._status);

  int get postID => _postID;
  int get userEntityID => _userEntityID;
  DateTime get endDate => _endDate;
  String get image => _image;
  String get title => _title;
  int get status => _status;

  set setStatus(int value) => _status = value;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["postID"] = this._postID;
    data["userEntityID"] = this._userEntityID;
    data["title"] = this._title;
    data["image"] = this._image;
    data["endDate"] = this._endDate;
    data["status"] = this._status;

    return data;
  }

  AppAcceptedChallenge.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._userEntityID = data["userEntityID"];
    this._postID = data["postID"];
    this._title = data["title"];
    this._image = data["image"]["path"];
    this._endDate = DateTime.parse(data["endDate"]);
    this._status = data["status"];
  }
}