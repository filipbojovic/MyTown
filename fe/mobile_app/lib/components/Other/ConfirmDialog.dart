import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  ConfirmDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.black
              ),
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              color: Colors.green,
              child: Text(
                'U redu',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}