
import 'package:flutter/material.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/services/api/administrator.api.dart';
import 'LoadingDialog.dart';

class ForgottenPasswordDialog extends StatefulWidget {
  @override
  _ForgottenPasswordDialogState createState() => _ForgottenPasswordDialogState();
}

class _ForgottenPasswordDialogState extends State<ForgottenPasswordDialog> {

  final TextEditingController _emailCon = new TextEditingController();
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.008,
          vertical: MediaQuery.of(context).size.width * 0.006,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            makeTitleLabel(context),
            SizedBox(height: MediaQuery.of(context).size.width * 0.004),
            makeDescriptionLabel(context),
            SizedBox(height: MediaQuery.of(context).size.width * 0.004),
            makeEmailField(),
            SizedBox(height: MediaQuery.of(context).size.width * 0.004),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                makeSendButton(),
                makeGiveUpButton() 
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.004),
            if(_showError) 
              makeErrorLabel(context)
          ],
        ),
      ),
    );
  }

  Text makeErrorLabel(BuildContext context) {
    return Text(
      'E-mail adresa ne postoji.',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.010,
        color: Colors.red,
      ),
    );
  }

  TextField makeEmailField() {
    return TextField(
      maxLines: 1,
      autofocus: false,
      controller: _emailCon,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
        hintText: "Unesite e-mail adresu",
        fillColor: Colors.grey[300],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            width: 0.0,
            style: BorderStyle.none
          )
        ),
      ),
    );
  }

  RaisedButton makeGiveUpButton() {
    return RaisedButton(
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      onPressed: (){
        Navigator.pop(context);
      },
      child: Text('Odustani', style: TextStyle(color: Colors.white)),
    );
  }

  RaisedButton makeSendButton() {
    return RaisedButton(
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return LoadingDialog("Slanje zahteva...");
          }
        );
        await AdministratorAPIServices.resetUserPassword(_emailCon.text, UserTypeEnum.administrator)
          .then((res){
            Navigator.pop(context);
            FocusScope.of(context);
            if(res == "201")
              Navigator.pop(context);
            else if(res == "404")
             setState(() => _showError = true);
          });
        
      },
      child: Text('Pošalji zahtev', style: TextStyle(color: Colors.white)),
    );
  }

  Text makeDescriptionLabel(BuildContext context) {
    return Text(
      "Ukoliko ste zaboravili lozinku, možete iskoristiti polje ispod da unesete Vašu e-mail adresu na koju će Vam biti poslata nova lozinka.",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.01,
        height: 1.2,
        color: Colors.black
      ),
    );
  }

  Text makeTitleLabel(BuildContext context) {
    return Text(
      "Zaboravljena lozinka",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.012,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),
    );
  }
}