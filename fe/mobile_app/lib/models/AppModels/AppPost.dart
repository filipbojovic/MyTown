class AppPost
{
  int _id;
  String _title;
  String _description;
  int _userEntityID;
  String _firstName;
  String _lastName;
  List<String> _imageURLS;
  DateTime _date;
  int _cityID;
  String _cityName;
  int _likes;
  int _comments;
  String _categoryName;
  double _rating;
  double _latitude;
  double _longitude;
  bool _likedByUser;
  DateTime _endDate;
  String _userProfilePhotoURL;
  bool _acceptedByTheUser;
  int _solvedByTheUser;
  int _typeID;

  AppPost(this._id, this._title, this._description, this._userEntityID, this._firstName, this._lastName, this._imageURLS, this._date, this._cityID, this._likes, this._comments, this._categoryName, this._rating, this._latitude, this._longitude, this._likedByUser, this._endDate, this._userProfilePhotoURL, this._acceptedByTheUser, this._solvedByTheUser, this._typeID);
  AppPost.withOutId(this._title, this._description, this._userEntityID, this._firstName, this._lastName, this._imageURLS, this._date, this._cityID, this._likes, this._comments, this._categoryName, this._rating, this._latitude, this._longitude, this._likedByUser, this._endDate, this._userProfilePhotoURL, this._acceptedByTheUser, this._solvedByTheUser, this._typeID);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get shortDescription => nadjiShortDesc(_description);
  int get userEntityID => _userEntityID;
  String get fullName => _firstName +" " +_lastName;
  bool get institution => _lastName == "" ? true : false;
  List<String> get imageURLS => _imageURLS;
  DateTime get date => _date;
  int get likes => _likes;
  int get cityID => _cityID;
  String get cityName => _cityName;
  int get comments => _comments;
  String get categoryName => _categoryName;
  double get rating => _rating;
  double get latitude => _latitude;
  double get longitude => _longitude;
  bool get likedByUser => _likedByUser;
  DateTime get endDate => _endDate;
  String get userProfilePhotoURL => _userProfilePhotoURL;
  bool get acceptedByTheUser => _acceptedByTheUser;
  int get solvedByTheUser => _solvedByTheUser;
  int get typeID => _typeID;

  set setLikedByUser(bool likedByUser) => _likedByUser = likedByUser;
  set setLikeCount(int likes) => _likes = likes;
  set setAcceptedByTheUser(bool value) => _acceptedByTheUser = value;
  set setSolvedByTheUser(int value) => _solvedByTheUser = value;
  set setTitle(String value) => _title = value;
  set setDescription(String value) => _description = value;
  set setEndDate(DateTime value) => _endDate = value;
  set setComments(int value) => _comments = value;
  
  void incrementCommentCount(int value)
  {
    this._comments += value;
  }
  

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    if(id != null)
      data["id"] = this._id;
    data["title"] = this._title;
    data["description"] = this._description;
    data["userEntityID"] = this._userEntityID;
    data["firstName"] = this._firstName;
    data["lastName"] = this._lastName;
    data["imageURLS"] = this._imageURLS;
    data["date"] = this._date.toIso8601String();
    data["cityID"] = this._cityID;
    data["likes"] = this._likes;
    data["comments"] = this._comments;
    data["categoryName"] = this._categoryName;
    data["rating"] = this._rating;
    data["latitude"] = this._latitude;
    data["longitude"] = this._longitude;
    data["likedByUser"] = this._likedByUser;
    data["endDate"] = this._endDate;
    data["userProfilePhotoURL"] = this._userProfilePhotoURL;
    data["acceptedByTheUser"] = this._acceptedByTheUser;
    data["solvedByTheUser"] = this._solvedByTheUser;
    data["typeID"] = this._typeID;

    return data;
  }
  String nadjiShortDesc(String _description)
  {
    if(_description.length < 130) return _description;
    else return _description.substring(0,(_description.substring(0,130).lastIndexOf(" ")))+"...";
  }

  AppPost.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._title = data["title"];
    this._description = data["description"];
    this._userEntityID = data["userEntityID"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];

    var mapURLs = data["imageURLS"];
    List<String> urls = new List<String>();
    this._imageURLS = urls;
    if(mapURLs != null && mapURLs.length > 0)
    {
      for(var url in mapURLs)
        urls.add(url["path"]);
      this._imageURLS = urls;
    }
    
    
    this._date = DateTime.parse(data["date"]);
    this._cityID = data["cityID"];
    this._cityName = data["cityName"];
    this._likes = data["likes"];
    this._comments = data["comments"];
    this._categoryName = data["categoryName"];
    this._rating = data["rating"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
    this._likedByUser = data["likedByUser"];
    if(data["endDate"] != null)
      this._endDate = DateTime.parse(data["endDate"]);
    this._userProfilePhotoURL = data["userProfilePhotoURL"];
    this._acceptedByTheUser = data["acceptedByTheUser"];
    this._solvedByTheUser = data["solvedByTheUser"];
    this._typeID = data["typeID"];
  }
}