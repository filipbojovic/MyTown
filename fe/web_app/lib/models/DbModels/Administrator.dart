class Administrator
{
  int _id;
  String _username;
  String _email;
  DateTime _joinDate;
  String _password;
  bool _head;

  Administrator(this._username, this._email, this._joinDate, this._password);

  int get id => this._id;
  String get username => this._username;
  String get email => this._email;
  DateTime get joinDate => this._joinDate;
  bool get head => this._head;
  String get fullName => this._username;
  
  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["username"] = this._username;
    data["email"] = this._email;
    data["joinDate"] = this._joinDate.toIso8601String();
    data["password"] = this._password;
    
    return data;
  }

  Administrator.fromObject(dynamic data) //constructor which creates category from map
  {
    this._id = data["id"];
    this._username = data["username"];
    this._email = data["email"];
    this._joinDate = DateTime.parse(data["joinDate"]);
    this._password = data["password"];
    this._head = data["head"];
  }
}