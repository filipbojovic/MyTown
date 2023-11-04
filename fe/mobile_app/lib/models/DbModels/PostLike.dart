class PostLike
{
  int _postID;
  int _userID;

  PostLike(this._postID, this._userID);

  int get entityID => _postID;
  int get userID => _userID;
  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();
    
    data["postID"] = this._postID;
    data["userID"] = this._userID;

    return data;
  }

  PostLike.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._postID = data["postID"];
    this._userID = data["userID"];
  }

}