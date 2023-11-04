class TypeStats
{
  int _id;
  String _name;
  int _numOfPosts;

  int get id => this._id;
  String get name => this._name;
  int get numOfPosts => this._numOfPosts;

  TypeStats.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._name = data["name"];
    this._numOfPosts = data["numOfPosts"];
  }
}