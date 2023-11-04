class AppNotification
{
  String _header;
  String _userProfilePhoto;
  String _postPhotoURL;
  DateTime _date;
  int _postID;
  int _notificationType;

  AppNotification(this._header, this._userProfilePhoto, this._postPhotoURL, this._date, this._postID, this._notificationType);
  
  String get header => _header;
  String get userProfilePhoto => _userProfilePhoto;
  String get postPhotoURL => _postPhotoURL;
  DateTime get date => _date;
  int get postID => _postID;
  int get notificationType => _notificationType;

  // Map<String, dynamic> toMap()
  // {
  //   var data = Map<String, dynamic>();
  // }

  AppNotification.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._header = data["header"];
    this._userProfilePhoto = data["userProfilePhoto"]["path"];
    this._postPhotoURL = data["postImage"] != null ? data["postImage"]["path"] : null;
    this._date = DateTime.parse(data["date"]);
    this._postID = data["postID"];
    this._notificationType = data["notificationType"];
  }
}