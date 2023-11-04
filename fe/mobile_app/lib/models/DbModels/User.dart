class User
{
  String _firstName;
  String _lastName;
  String _email;
  int _cityID;
  DateTime _birthDay;
  int _genderID;
  DateTime _joinDate;

  User.withOutId(this._firstName, this._lastName, this._email, this._cityID, this._birthDay, this._genderID, this._joinDate);

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  int get cityID => _cityID;
  DateTime get birthDay => _birthDay;
  int get genderID => _genderID;
  DateTime get joinDate => _joinDate;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["firstName"] = this._firstName;
    data["lastName"] = this._lastName;
    data["email"] = this._email;
    data["cityID"] = this._cityID;
    data["birthDay"] = this._birthDay.toIso8601String();
    data["genderID"] = this._genderID;
    data["joinDate"] = this._joinDate.toIso8601String();

    return data;
  }
}