class Post
{
  int _id;
  String _title;
  String _description;
  int _userEntityID;
  DateTime _date;
  int _cityID;
  int _categoryID;
  double _latitude;
  double _longitude;
  DateTime _endDate;
  int _typeID;

  Post(this._id, this._title, this._description, this._userEntityID, this._date,  this._categoryID, this._cityID, this._latitude, this._longitude, this._endDate, this._typeID);
  Post.withOutId(this._title, this._description, this._userEntityID, this._date,  this._categoryID, this._cityID, this._latitude, this._longitude, this._endDate, this._typeID);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get userEntityID => _userEntityID;
  DateTime get date => _date;
  int get categoryID => _categoryID;//ca
  int get cityID => _cityID;
  double get latitude => _latitude;//l
  double get longitude => _longitude;
  DateTime get endDate => _endDate;
  int get typeID => _typeID;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    if(id != null)
      data["id"] = this._id;
    if(title != null)
      data["title"] = this._title;
    data["description"] = this._description;
    data["userEntityID"] = this._userEntityID;
    data["date"] = this._date.toIso8601String();
    data["categoryID"] = this._categoryID;
    data["cityID"] = this._cityID;
    data["latitude"] = this._latitude;
    data["longitude"] = this._longitude;
    if(endDate != null)
      data["endDate"] = this._endDate.toIso8601String();
    data["typeID"] = this._typeID;

    return data;
  }

  Post.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._title = data["title"];
    this._description = data["description"];
    this._userEntityID = data["userEntityID"];
    this._date = DateTime.parse(data["date"]);
    this._categoryID = data["categoryID"];
    this._cityID = data["cityID"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
    this._endDate = DateTime.parse(data["endDate"]);
    this._typeID = data["typeID"];
  }

}
