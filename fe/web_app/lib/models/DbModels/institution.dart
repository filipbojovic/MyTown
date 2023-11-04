class Institution
{
  String _name;
  int _headquaterID;
  String _email;
  String _password;
  String _address;
  String _phone;
  DateTime _joinDate;


  Institution(this._name, this._headquaterID, this._email, this._password, this._address, this._phone, this._joinDate);
  
  Map<String, dynamic> toMap(){
    var data  = Map<String, dynamic>();

    data["name"] = this._name;
    data["headquaterID"] = this._headquaterID;
    data["email"] = this._email;
    data["password"] = this._password;
    data["address"] = this._address;
    data["phone"] = this._phone;
    data["joinDate"] = this._joinDate.toIso8601String();

    return data;
  }
}