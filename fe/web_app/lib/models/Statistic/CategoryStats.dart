class CategoryStats
{
  int _id;
  String _name;
  int _numOfChallenges;

  int get id => this._id;
  String get name => this._name;
  int get numOfChallenges => this._numOfChallenges;

  CategoryStats.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._name = data["name"];
    this._numOfChallenges = data["numOfChallenges"];
  }
}