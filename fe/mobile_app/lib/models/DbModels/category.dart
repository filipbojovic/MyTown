class MyCategory
{
  int _id;
  String _name;

  MyCategory(this._id, this._name);
  MyCategory.withOutId(this._name);

  int get id => _id;
  String get name => _name;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["name"] = this._name;

    if(_id != null)
      data["id"] = this._id;

    return data;
  }

  MyCategory.fromObject(dynamic data) //constructor which creates category from map
  {
    this._id = data["id"];
    this._name = data["name"];
  }
}