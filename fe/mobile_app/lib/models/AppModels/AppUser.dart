class AppUser
{
  int _id;
  String _firstName;
  String _lastName;
  String _email;
  int _ecoFPoints;
  String _city;
  int _cityID;
  int _numOfPosts;
  int _numOfAcceptedChallenges;
  int _numOfSolvedChallenges;
  DateTime _birthDay;
  int _genderID;
  DateTime _joinDate;
  String _profilePhotoURL;
  String _token;
  bool _unreadNotification;
  String _rankPhotoURL;
  String _rankName;

  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  int get ecoFPoints => _ecoFPoints;
  int get cityID => _cityID;
  String get city => _city;
  int get numOfPosts => _numOfPosts;
  int get numOfAcceptedChallenges => _numOfAcceptedChallenges;
  int get numOfSolvedChallenges => _numOfSolvedChallenges;
  DateTime get birthDate => _birthDay;
  int get genderID => _genderID;
  DateTime get joinDate => _joinDate;
  String get profilePhotoURL => _profilePhotoURL;
  String get fullName => _firstName +" " +_lastName;
  String get token => _token;
  bool get unreadNotification => _unreadNotification;
  String get rankPhotoURL => _rankPhotoURL;
  String get rankName => _rankName;

  set setCityID(int cityID) => _cityID = cityID;
  set setLastName(String cityID) => _lastName = cityID;
  set setFirstName(String cityID) => _firstName = cityID;
  set setEmail(String email) => _email = email;
  set setCity(String city) => _city = city;
  set setUnreadNotification(bool value) => _unreadNotification = value;
  set setNumOfAcceptedChallenges(int value) => _numOfAcceptedChallenges = value;
  
  void substractPoints()
  {
    this._ecoFPoints -= 10;
  }

  void solveChallenge()
  {
    if(this._numOfSolvedChallenges > 1)
      this._numOfSolvedChallenges -= 1;
  }

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    if(_id != null)
      data["id"] = this._id;
    data["firstName"] = this._firstName;
    data["lastName"] = this._lastName;
    data["email"] = this._email;
    data["ecoFPoints"] = this._ecoFPoints;
    data["city"] = this._city;
    data["cityID"] = this._cityID;
    data["numOfPosts"] = this._numOfPosts;
    data["birthDay"] = this._birthDay;
    data["genderID"] = this._genderID;
    data["numOfSolvedChallenges"] = this._numOfSolvedChallenges;
    data["numOfAcceptedChallenges"] = this._numOfAcceptedChallenges;
    data["joinDate"] = this._joinDate;
    data["profilePhotoURL"] = this._profilePhotoURL;
    data["token"] = this.token;
    data["unreadNotification"] = this._unreadNotification;
    data["rankPhotoURL"] = this._rankPhotoURL;
    data["rankName"] = this._rankName;

    return data;
  }

  AppUser.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._id = data["id"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];
    this._email = data["email"];
    this._ecoFPoints = data["ecoFPoints"];
    this._city = data["city"];
    this._cityID = data["cityID"];
    this._numOfPosts = data["numOfPosts"];
    this._numOfSolvedChallenges = data["numOfSolvedChallenges"];
    this._numOfAcceptedChallenges = data["numOfAcceptedChallenges"];
    this._birthDay = DateTime.parse(data["birthDay"]);
    this._genderID = data["genderID"];
    this._joinDate = DateTime.parse(data["joinDate"]);
    this._profilePhotoURL = data["profilePhotoURL"];
    this._token = data["token"];
    this._unreadNotification= data["unreadNotification"];
    this._rankPhotoURL = data["rankPhotoURL"];
    this._rankName = data["rankName"];
  }

}