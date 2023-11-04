class AppRank
{
  int _id;
  String _name;
  int _startPoints;
  int _endPoints;
  String _path;
  String _fileName;


  AppRank(this._id, this._name, this._startPoints, this._endPoints, this._fileName);
  AppRank.withOutId(this._name, this._startPoints, this._endPoints, this._fileName);

  int get id => _id;
  String get name => _name;
  int get startPoints => _startPoints;
  int get endPoints => _endPoints;
  String get path => _path;
  String get fileName => _fileName;


  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    if(_id != null)
      data["id"] = this._id;
    data["name"] = this._name;
    data["startPoints"] = this._startPoints;
    data["endPoints"] = this._endPoints;
    data["path"] = this._path;
    data["fileName"] = this._fileName;

    return data;
  }

  AppRank.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._name = data["name"];
    this._startPoints = data["startPoints"];
    this._endPoints = data["endPoints"];
    this._path = data["path"];
    this._fileName = data["fileName"];
  }

}