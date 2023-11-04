class PostReport
{
  int _postID;
  int _senderID;
  int _reportedUserID;
  DateTime _date;
  String _text;

  PostReport(this._postID, this._senderID, this._reportedUserID, this._date, this._text);

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();

    data["postID"] = this._postID;
    data["senderID"] = this._senderID;
    data["reportedUserID"] = this._reportedUserID;
    data["date"] = this._date.toIso8601String();
    data["text"] = this._text;

    return data;
  }
}