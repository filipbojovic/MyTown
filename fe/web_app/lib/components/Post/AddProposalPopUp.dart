import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/services/api/comment.api.dart';
import 'package:web_app/models/DbModels/Comment.dart';

class AddProposalPopUP extends StatefulWidget {
  final Function changeSolveStatus;
  final AppPost post;
  AddProposalPopUP(this.changeSolveStatus, this.post);
  @override
  _AddProposalPopUPState createState() => _AddProposalPopUPState();
}

class _AddProposalPopUPState extends State<AddProposalPopUP> {

  TextEditingController _textCon = new TextEditingController();
  String _error;

  @override
  void initState() {
    _error = "";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return makeCommentPopUp(context);
  }

  Widget makeCommentPopUp(BuildContext _context){
    return Dialog(
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            makeCommentTextField(),
            if(data != null)
              makeOneImageView(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(_error != "")
                  makeErrorLabel(),
                SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                makeGiveUpButton(),
                SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                makeAddButton(_context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Material makeAddButton(BuildContext _context) {
    return Material(
      borderRadius: BorderRadius.circular(7.0),
      color: Colors.green,
      child: InkWell(
        hoverColor: Colors.green[700],
        splashColor: Colors.green[900],
        onTap: () async {
          Comment comment = new Comment.withOutID(widget.post.id, loggedUser.id, _textCon.text, null, DateTime.now(), null, null);
          if(_textCon.text == "")
          {
            setState(() => _error = "Unesite tekst rešenja.");
            return;
          }
          else if(data == null)
          {
            setState(() => _error = "Dodajte sliku rešenja.");
            return;
          }
          else if(_error != "")
            setState(() => _error = "");

          showDialog(
            context: _context,
            builder: (context){
              return LoadingDialog("Dodavanje rešenja...");
            }
          );

          await CommentAPIServices.addInstitutionProposal(comment, base64.encode(data))
            .then((value){

              if(value != null)
              {
                widget.changeSolveStatus();
                Navigator.pop(_context);
                Navigator.pop(context);
              }

            });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0)
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.002,
            horizontal: MediaQuery.of(context).size.width * 0.003,
          ),
          child: Text(
            'Dodaj',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.009
            ),
          ),
        ),
      ),
    );
  }

  Material makeGiveUpButton() {
    return Material(
      borderRadius: BorderRadius.circular(7.0),
      color: Colors.green,
      child: InkWell(
        hoverColor: hoverColor,
        splashColor: splashColor,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0)
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.002,
            horizontal: MediaQuery.of(context).size.width * 0.003,
          ),
          child: Text(
            'Odustani',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.009
            ),
          ),
        ),
      ),
    );
  }

  Widget makeErrorLabel()
  {
    return Container(
      child: Text(
        _error,
        style: TextStyle(
          color: Colors.red,
          fontSize: MediaQuery.of(context).size.width * 0.01,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Container makeCommentTextField() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 5.0,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Image.network(
            defaultServerURL + loggedUser.imageURL,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.width * 0.02,
            width: MediaQuery.of(context).size.height * 0.04,
          ),
          Expanded(
            child: TextField(
              controller: _textCon,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                hintText: 'Komentar rešenja...',
                // hoverColor: Colors.red,
                // fillColor: Colors.grey[300],
                filled: true,
                hoverColor: Colors.white,
                border: InputBorder.none
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            child: InkWell(
              onTap: (){
                pickImage();
              },
              hoverColor: themeColor,
              child: Icon(MaterialCommunityIcons.camera_outline)
            ),
          ),
        ],
      ),
    );
  }

  String name = '';
  String error;
  Uint8List data;

  pickImage() {
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return; 
      final reader = FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) async {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
            name = input.files[0].name;
            data = base64.decode(stripped);
            error = null;
          });
          
      });
    });

    input.click();
  }

  Widget makeOneImageView(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.002,
            horizontal: MediaQuery.of(context).size.width * 0.002,
          ),
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.05,
          child: Image.memory(
            data,
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              data = null;
            });
          },
          child: Icon(MaterialCommunityIcons.close_circle_outline)
        )
      ],
    );
  }
}