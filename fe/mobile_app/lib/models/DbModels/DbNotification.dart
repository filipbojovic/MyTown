class DbNotification 
{
  int id;
  String username;
  int userID;
  int userIDLiked;
  int idPost;
  String time;
  
  DbNotification(this.id, this.username, this.userID, this.userIDLiked,
      this.idPost, this.time);

  int get _id => id;
  String get _username => username;
  int get _userID => userID;
  int get id_user => userIDLiked;
  int get _comment => idPost;
  String get _time => time;

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data["id"] = this.id;
    data["username"] = this.username;
    data["userID"] = this.userID;
    data["userIDLiked"] = this.userIDLiked;
    data["idPost"] = this.idPost;
    data["time"] = this.time;
    return data;
  }

  DbNotification.fromObject(dynamic data) {
    this.id = data["id"];
    this.username = data["username"];
    this.userID = data["userID"];
    this.userIDLiked = data["userIDLiked"];
    this.idPost = data["idPost"];
    this.time = data["time"];
  }
}
