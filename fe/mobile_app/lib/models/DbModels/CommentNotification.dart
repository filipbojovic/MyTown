class CommentNotification 
{
  int _senderID;
  int _receiverID;
  int _postID;
  int _commentID;
  int _notificationTypeID;
  bool _read;
  DateTime _date;
  
  CommentNotification(this._senderID, this._receiverID, this._postID, this._commentID, this._notificationTypeID, this._read, this._date);

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();
    
    data["senderID"] = this._senderID;
    data["receiverID"] = this._receiverID;
    data["postID"] = this._postID;
    data["commentID"] = this._commentID;
    data["notificationTypeID"] = this._notificationTypeID;
    data["read"] = this._read;
    data["date"] = this._date.toIso8601String();

    return data;
  }
}
