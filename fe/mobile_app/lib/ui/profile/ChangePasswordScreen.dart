import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  
  final password = TextEditingController();
  final newPassword = TextEditingController();
  final newPassword2 = TextEditingController();
  String _error;

  @override
  void initState() {
    _error = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            makeOldPasswordField(),
            SizedBox(height: 10.0),
            makeNewPasswordField(),
            SizedBox(height: 10.0),
            makeNetPassword2Field(),
            SizedBox(height: 10.0),
            if(_error != "")
              makeErrorField(),
          ],
        ),
      )
    );
  }

  AppBar makeAppBar(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        makeDoneButton(context)
      ],
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        }
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      title: Text("Izmena lozinke", style: TextStyle(color: Colors.grey[900]),),
    );
  }

  Widget makeErrorField()
  {
    return Text(
      _error,
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.042
      ),
    );
  }

  TextFormField makeNetPassword2Field() {
    return TextFormField(
      obscureText: true,
      controller: newPassword2,
      decoration: InputDecoration(
        hintText: "Ponovite novu lozinku",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800]),
        ),
        labelStyle: TextStyle(fontSize: 20)
      ),
    );
  }

  TextFormField makeNewPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: newPassword,
      decoration: InputDecoration(
        hintText: "Nova lozinka",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800]),
        ),
        labelStyle: TextStyle(fontSize: 20)
      ),
    );
  }

  Widget makeOldPasswordField() {
    return TextFormField(
      obscureText: true,
        controller: password,
        decoration: InputDecoration(
          hintText: "Trenutna lozinka",
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800]),
        ),
        ),
    );
  }

  IconButton makeDoneButton(BuildContext context) {
    return new IconButton(
      icon: Icon(Icons.done),
      onPressed: () async {
         var check = validateData(password.text, newPassword.text, newPassword2.text);
        
        if(check)
        {
          await UserAPIServices.changeUserPassword(loggedUser.id, password.text, newPassword.text)
            .then((value){
              if(value == "204")
                Navigator.pop(context);
              else if(value =="409")
                setState(() => "Trenutna lozinka nije odgovarajuća.");
              else
                setState(() => "Došlo je do greške, proverite internet konekciju.");
            });
        }
      },
    );
  }

  bool validateData(String oldPassword, String newPassword1, String newpassword2)
  {
    RegExp passRegExp = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

    if(password.text == "")
    {
      setState(() => _error = "Unesite trenutnu lozinku.");
      return false;
    }
    else if(newPassword.text == "")
    {
      setState(() => _error = "Unesite novu lozinku.");
      return false;
    }
    else if(newPassword2.text == "")
    {
      setState(() => _error = "Potvrdite novu lozinku.");
      return false;
    }
    else if(!passRegExp.hasMatch(newPassword1))
    {
      setState(() => _error = "Lozinka mora imati najmanje 8 karaktera, bar jednu cifru i veliko slovo.");
      return false;
    }
    else if(newPassword1 != newpassword2)
    {
      setState(() => _error = "Nova lozinka se ne poklapa.");
      return false;
    }
    else
    {
      setState(() => _error = "");
      return true;
    }
  }
}