class CommentReport
{
  int _postID;
  int _commentID;
  int _senderID;
  int _reportedUserID;
  DateTime _date;
  String _text;

  CommentReport(this._postID, this._commentID, this._senderID, this._reportedUserID, this._date, this._text);

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["postID"] = this._postID;
    data["commentID"] = this._commentID;
    data["senderID"] = this._senderID;
    data["reportedUserID"] = this._reportedUserID;
    data["date"] = this._date.toIso8601String();
    data["text"] = this._text;

    return data;
  }
}