class UploadImage
{
  int _id;
  int _typeID;
  int _userID;
  String _path;
  String _name;

  UploadImage(this._id, this._typeID, this._userID, this._path, this._name);
  UploadImage.withOutID(this._typeID, this._userID, this._path, this._name);

  int get id => _id;
  int get typeID => _typeID;
  int get userID => _userID;
  String get path => _path;
  String get name => _name;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    if(_id != null)
      data["ID"] = this._id;
    data["typeID"] = this.typeID;
    data["userID"] = this.userID;
    data["path"] = this.path;
    data["name"] = this._name;

    return data;
  }

  UploadImage.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._typeID = data["typeID"];
    this._userID = data["userID"];
    this._path = data["path"];
    this._name = data["name"];
  }
}