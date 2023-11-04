class Rank
{
  //Rank.fromObject(dynamic data);

  int _id;
  String _name;
  int _startPoint;
  int _endPoint;
  String _path;
  String _fileName;

  Rank(this._id, this._name, this._startPoint, this._endPoint, this._path);
  Rank.withOutId(this._name, this._startPoint, this._endPoint, this._path);

  int get id => _id;
  String get name => _name;
  int get startPoints => _startPoint;
  int get endPoints => _endPoint;
  String get path => _path;
  String get fileName => _fileName;

  set setStartPoints(int value) => _startPoint = value;
  set setEndPoints(int value) => _endPoint = value;
  set setName(String name) => _name = name;
  set setPath(String path) => _path = path;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    if(_id != null)
      data["id"] = this._id;
    data["name"] = this._name;
    data["startPoint"] = this._startPoint;
    data["endPoint"] = this._endPoint;
    data["path"] = this._path;
    data["fileName"] = this._fileName;

    return data;
  }

  Rank.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._name = data["name"];
    this._startPoint = data["startPoint"];
    this._endPoint = data["endPoint"];
    this._path = data["path"];
    this._fileName = data["fileName"];
  }

}