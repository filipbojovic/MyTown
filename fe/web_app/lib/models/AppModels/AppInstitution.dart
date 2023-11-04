class AppInstitution
{
  int _id;
  String _name;
  int _headquaterID;
  String _headquaterName;
  String _address;
  String _email;
  String _phone;
  DateTime _joinDate;
  String _imageURL;
  int _numOfPost;

  AppInstitution(this._id, this._name, this._headquaterID, this._headquaterName, this._address, this._email, this._phone, this._joinDate, this._imageURL, this._numOfPost);

  int get id => _id; 
  String get name => _name;
  int get headquaterID => _headquaterID;
  String get headquaterName => _headquaterName;
  String get address => _address;
  String get email => _email;
  String get phone => _phone;
  DateTime get joinDate => _joinDate;
  String get imageURL => _imageURL;
  int get numOfPost => _numOfPost;
  String get fullName => this._name;

  set setName(String value) => _name = value;
  set setHeadquaterID(int value) => _headquaterID = value;
  set setHeadquaterName(String value) => _headquaterName = value;
  set setAddress(String value) => _address = value;
  set setEmail(String value) => _email = value;
  set setPhone(String value) => _phone = value;
  set setImageURL(String value) => _imageURL = value;
  
  AppInstitution.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._name = data["name"];
    this._headquaterID = data["headquaterID"];
    this._headquaterName = data["headquaterName"];
    this._address = data["address"];
    this._email = data["email"];
    this._phone = data["phone"];
    this._joinDate = DateTime.parse(data["joinDate"]);
    this._imageURL = data["imageURL"];
    this._numOfPost = data["numOfPost"];
  }
}