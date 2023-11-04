class TopUser
{
  int _id;
  String _photoURL;
  String _fullName;
  int _points;

  int get id => this._id;
  String get photoURL => this._photoURL;
  String get fullName => this._fullName;
  int get points => this._points;

  TopUser.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._photoURL = data["photoURL"];
    this._fullName = data["fullName"];
    this._points = data["points"];
  }
}