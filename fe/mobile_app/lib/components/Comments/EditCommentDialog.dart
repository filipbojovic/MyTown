import 'package:bot_fe/models/AppModels/AppProposal.dart';
import 'package:bot_fe/services/api/comment.api.dart';
import 'package:flutter/material.dart';

class EditCommentDialog extends StatefulWidget {
  final AppProposal comment;
  final Function update;
  EditCommentDialog(this.comment, this.update);
  @override
  _EditCommentDialogState createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<EditCommentDialog> {

  final TextEditingController _textCon = new TextEditingController();
  String _error = "";

  @override
  void initState() {
    _textCon.text = widget.comment.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: makeBody()
    );
  }

  Widget makeBody()
  {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Column(
        children: [
          makeTitleField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              makeGiveUpButton(),
              SizedBox(width: 5.0),
              makeSaveButton(),
            ],
          ),
          if(_error != "")
          Text(
            _error,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: MediaQuery.of(context).size.width * 0.04),
          )
        ],
      ),
    );
  }

  Widget makeTitleField()
  {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.width * 0.01,
      ),
      child: TextField(  
        controller: _textCon,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
            hintText: 'tekst',
            fillColor: Colors.grey[300],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                width: 0.0,
                style: BorderStyle.none
              )
            ),
        )
      ),
    );
  }

  Widget makeSaveButton()
  {
    return RaisedButton(
      child: Text('Izmeni'),
      onPressed: () async {
        var check = _validateData();

        if(check)
        {
          var mapData = new Map<String, dynamic>();
          mapData["id"] = widget.comment.id;
          mapData["postID"] = widget.comment.postID;
          mapData["text"] = _textCon.text;
          await CommentAPIServices.changeCommentText(mapData);
          widget.update(_textCon.text);
          Navigator.pop(context, _textCon.text);
        }

      },
    );
  }

  Widget makeGiveUpButton()
  {
    return RaisedButton(
      child: Text('Odustani'),
      onPressed: (){
        Navigator.pop(context);
      },
    );
  }

  bool _validateData()
  {
    String text = _textCon.text;

    if(text == "")
    {
      setState(() {
        _error = "Komentar ne može biti prazan.";
      });
      return false;
    }
    else
      return true;
  }
}