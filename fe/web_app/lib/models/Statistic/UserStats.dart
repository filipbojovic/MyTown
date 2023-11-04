class UserStats {
  int _id;
  String _firstName;
  String _lastName;
  DateTime _birthDate;
  DateTime _joinDate;
  int _genderID;
  int _numOfEcoFPoints;

  int get id => this._id;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get fullName => this._firstName + ' ' + this._lastName;
  DateTime get birthDate => this._birthDate;
  DateTime get joinDate => this._joinDate;
  int get genderID => this._genderID;
  int get numOfEcoFPoints => this._numOfEcoFPoints;

  UserStats.fromObject(dynamic data) {
    this._id = data["id"];

    this._firstName = data["firstName"];

    this._lastName = data["lastName"];

    this._birthDate = DateTime.parse(data["bithDate"]);

    this._joinDate = DateTime.parse(data["joinDate"]);

    this._genderID = data["genderID"];

    this._numOfEcoFPoints = data["numOfEcoFPoints"];
  }
}
