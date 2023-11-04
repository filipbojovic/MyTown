class CityStats
{
  int _id;
  String _name;
  int _numberOfChallenges;

  int get id => this._id;
  String get name => this._name;
  int get numberOfChallenges => this._numberOfChallenges;

  CityStats.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._name = data["name"];
    this._numberOfChallenges = data["numberOfChallenges"];
  }
}