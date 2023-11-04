import 'package:bot_fe/components/Other/PickerComponent.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:flutter/material.dart';

class EditPostScreen extends StatefulWidget {
  final AppPost post;
  EditPostScreen(this.post);
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {

  final TextEditingController _descCon = new TextEditingController();
  final TextEditingController _titleCon = new TextEditingController();
  DateTime _dateTime;
  String _error = "";

  _updateDate(DateTime newDate)
  {
    setState(() {
      _dateTime = newDate;
    });
  }

  makeDateFormat(DateTime date)
  {
    var dateString = date.day.toString() +"." +date.month.toString() +"." +date.year.toString();
    dateString += " " +date.hour.toString() +":" +date.minute.toString();
    return dateString;
  }

  @override
  void initState() {
    _descCon.text = widget.post.description;
    _titleCon.text = widget.post.title;
    
    if(widget.post.endDate != null)
      _dateTime = widget.post.endDate.isBefore(DateTime.now()) ? DateTime.now().add(Duration(days: 1)) : widget.post.endDate.add(Duration());

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
          if(widget.post.typeID == PostTypeEnum.challengePost) makeTitleField(),
          makeDescriptionField(),
          if(widget.post.typeID == PostTypeEnum.challengePost) makeDateLabel(),
          if(widget.post.typeID == PostTypeEnum.challengePost) makeDatePickerField(),
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

  Container makeDateLabel() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02
      ),
      child: Text(
        "Vremensko ograničenje: " +makeDateFormat(_dateTime),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
      )
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
        controller: _titleCon,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
            hintText: 'opis',
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

  Widget makeDescriptionField()
  {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.width * 0.01,
      ),
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01
      ),
      child: TextField(  
        controller: _descCon,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
            hintText: 'opis',
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

  Widget makeDatePickerField()
  {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01
      ),
      child: PickerComponent(widget.post.endDate.isBefore(DateTime.now()) ? DateTime.now() : widget.post.endDate, _updateDate)
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

  Widget makeSaveButton()
  {
    return RaisedButton(
      child: Text('Izmeni'),
      onPressed: () async {
        var check = _validateData();

        if(check)
        {
          Map<String, dynamic> data = new Map<String, dynamic>();
          data["id"] = widget.post.id;
          data["endDate"] = widget.post.typeID == PostTypeEnum.challengePost ?  _dateTime.toIso8601String() : null;
          data["title"] = widget.post.typeID == PostTypeEnum.challengePost ? _titleCon.text : null;
          data["description"] = _descCon.text;

          var res = await ChallengeAPIServices.changePostData(data);

          if(res == "404")
            Navigator.pop(context, res);
          else
            Navigator.pop(context, data);
        }
      },
    );
  }

  bool _validateData()
  {
    String desc = _descCon.text;

    if(widget.post.typeID == PostTypeEnum.challengePost)
    {
      String title = _titleCon.text;

      if(title == "")
      {
        setState(() {
          _error = "Naslov ne može biti prazan.";
        });
        return false;
      }
      else if(desc == "")
      {
        setState(() {
          _error = "Opis ne može biti prazan.";
        });
        return false;
      }
      else
      {
        setState(() {
          _error = "";
        });
        return true;
      }
    }
    else
    {
      if(desc == "")
      {
        setState(() {
          _error = "Opis ne može biti prazan.";
        });
        return false;
      }
      else
      {
        setState(() {
          _error = "";
        });
        return true;
      }
    }
  }
}