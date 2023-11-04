import 'package:bot_fe/components/Other/LoadingDialog.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:flutter/material.dart';

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
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.width * 0.03,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            makeTitleLabel(context),
            SizedBox(height: MediaQuery.of(context).size.width * 0.03),
            makeDescriptionLabel(context),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
            makeEmailField(),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                makeSendButton(),
                makeGiveUpButton() 
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
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
        fontSize: MediaQuery.of(context).size.width * 0.037,
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
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
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

        await UserAPIServices.resetUserPassword(_emailCon.text, UserTypeEnum.user)
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
        fontSize: MediaQuery.of(context).size.width * 0.04,
        height: 1.2,
        color: Colors.black
      ),
    );
  }

  Text makeTitleLabel(BuildContext context) {
    return Text(
      "Zaboravljena lozinka",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.w500,
        color: Colors.black
      ),
    );
  }
}