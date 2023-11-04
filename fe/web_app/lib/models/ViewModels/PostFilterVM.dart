class PostFilterVM
{
  int _userEntityID;
  int _cityID;
  int _categoryID;
  bool _challengePost;
  bool _userPost;
  bool _institutionPost;
  int _counter;

  PostFilterVM(this._userEntityID, this._cityID, this._categoryID, this._challengePost, this._userPost, this._institutionPost, this._counter);

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["userEntityID"] = this._userEntityID;
    data["cityID"] = this._cityID;
    data["categoryID"] = this._categoryID;
    data["challengePost"] = this._challengePost;
    data["userPost"] = this._userPost;
    data["institutionPost"] = this._institutionPost;
    data["counter"] = this._counter;

    return data;
  }
}