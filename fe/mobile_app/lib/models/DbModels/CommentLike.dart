class CommentLike
{
  int _commentID;
  int _postID;
  int _userEntityID;
  int _value;

  CommentLike(this._commentID, this._postID, this._userEntityID, this._value);

  int get commentID => _commentID;
  int get postID => _postID;
  int get userEntityID => _userEntityID;
  int get value => _value;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();
    
    data["commentID"] = this._commentID;
    data["postID"] = this._postID;
    data["userEntityID"] = this._userEntityID;
    data["value"] = this._value;

    return data;
  }

  CommentLike.fromObject(dynamic data) //constructor which creates user from object(map)
  {
    this._commentID = data["commentID"];
    this._postID = data["postID"];
    this._userEntityID = data["userEntityID"];
    this._value = data["value"];
  }
}