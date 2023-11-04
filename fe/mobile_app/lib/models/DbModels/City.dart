class City
{
  int _id;
  String _name;

  City(this._id, this._name);

  int get id => _id;
  String get name => _name;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();
    
    data["id"] = this.id;
    data["name"] = this._name;

    return data;
  }

  City.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._name = data["name"];
  }
}