import 'package:flutter/material.dart';

class DeleteAlertDialog extends StatelessWidget {
  final String message;
  DeleteAlertDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.width * 0.003,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.01,
                color: Colors.black
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.003),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                makeOkButton(context),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                makeGiveUpButton(context)
              ],
            )
          ],
        ),
      ),
    );
  }

  RaisedButton makeOkButton(BuildContext context) {
    return RaisedButton(
      onPressed: (){
        Navigator.pop(context, true);
      },
      color: Colors.green,
      child: Text(
        'Siguran sam',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  RaisedButton makeGiveUpButton(BuildContext context) {
    return RaisedButton(
      onPressed: (){
        Navigator.pop(context, false);
      },
      color: Colors.green,
      child: Text(
        'Odustani',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}