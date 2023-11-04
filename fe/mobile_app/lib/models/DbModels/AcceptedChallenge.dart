class AcceptedChallenge
{
  int _postID;
  int _userEntityID;

  AcceptedChallenge(this._postID, this._userEntityID);

  int get postEntityID => _postID;
  int get userEntityID => _userEntityID;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["postID"] = this._postID;
    data["userEntityID"] = this._userEntityID;

    return data;
  }

  AcceptedChallenge.fromObject(dynamic data) //constructor which creates category from map
  {
    this._postID = data["postID"];
    this._userEntityID = data["userEntityID"];
  }
}