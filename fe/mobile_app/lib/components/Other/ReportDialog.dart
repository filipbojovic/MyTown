import 'package:flutter/material.dart';

class ReportDialog extends StatelessWidget {

  final String fullName;
  ReportDialog(this.fullName);

  @override
  Widget build(BuildContext context) 
  {
    TextEditingController _commentController = new TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      buttonPadding: EdgeInsets.symmetric(vertical: 0),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.045
      ),
      titlePadding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.03
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.width * 0.02,
      ),
      actionsPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.width * 0.01,
      ),
      title: Text('Prijava za korisnika ' +fullName),
      content: TextField(
        maxLines: null,
        controller: _commentController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          hintText: 'Molimo Vas unesite razlog prijave...',
          fillColor: Colors.grey[300],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 0.0,
              style: BorderStyle.none
            )
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Pošalji', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
          onPressed: (){
            Navigator.pop(context, _commentController.text);
          },
        ),
        FlatButton(
          child: Text('Odustani', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}