import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_app/components/Other/ForgottenPasswordDialog.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/services/api/administrator.api.dart';
import 'package:web_app/services/api/institution.api.dart';
import 'package:web_app/services/api/user.api.dart';
import 'package:web_app/services/storage.services.dart';
import 'package:web_app/ui/HomeScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  static TextEditingController emailController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();

  String _error = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        ),
      ) : Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            makeLogo(),
            makeLoginCard()
          ],
        ),
      ),
    ),
    );
  }

  Widget makeLogo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(  
        image: DecorationImage(image: AssetImage(logoPath), fit: BoxFit.contain)
      ),
    );
  }

  Widget makeLoginCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          makeFieldsView(),
          makeForgotPasswordField(),
          //RememberMeCheckBox(),
          _error != "" ? Text(
              _error,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ):Container(),
          makeLoginButton(),
        ],
      ),
    );
  }

  Widget makeFieldsView() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          makeFirstField(),
          makePasswordField(),
        ],
      ),
    );
  }

  Widget makeLoginButton()
  {
    return RaisedButton(
      onPressed: () async {
        logInFunction();
      },
      color: Colors.green[600],
      textColor: Colors.white,
      child: Text(
        'Prijavite se',
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.013),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(13.0))),
    );
  }

  Container makeForgotPasswordField() {
    return Container(
      alignment: Alignment(1.0, 0.0),
      child: InkWell(
        child: Text(
          'Zaboravljena lozinka?',
          style: TextStyle(
            color: Colors.green[600], fontWeight: FontWeight.bold),
        ),
        onTap: () {
          showDialog(
            context: context,
            child: ForgottenPasswordDialog()
          );
        },
      ),
    );
  }

  AlertDialog makeWrongDataDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Greška",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
          "Loša kombinacija korisničkog imena/lozinke."),
      actions: <Widget>[
        FlatButton(
          child: Center(
              child: Text(
            'Pokušaj ponovo',
            style: TextStyle(color: Colors.grey[900]),
          )),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget makeFirstField()
  {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[700])),
      ),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.supervised_user_circle,
            color: Colors.green[600],
          ),
          hintText: "e-mail adresa",
        ),
      ),
    );
  }

  Widget makePasswordField()
  {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[700])),
      ),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.lock,
              color: Colors.green[600],
            ),
            hintText: 'Lozinka'),
          onFieldSubmitted: (value){
            logInFunction();
          },
      ),
    );
  }

   logInFunction() async{
    if(emailController.text != ""){
      var res = await UserAPIServices.administratorLogin(emailController.text, passwordController.text);

      if (res != null) {
        setState((){ 
          _isLoading = true;
          _error = "";
        });
        res = res.substring(1, res.length - 1);
        Storage.setToken = res;
        var jwtParts = res.split(".");
        var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwtParts[1]))));
        String id = payload['nameid'];
        int typeID = int.parse(payload['sub'][1]);
            
        if(typeID == UserTypeEnum.administrator)
          loggedAdministrator = await AdministratorAPIServices.getAdministratorByID(id);
        else
          loggedUser = await InstitutionAPIServices.getAppInstitution(id);
            
        setState(() => _isLoading = false);
        Navigator.pushReplacement(context, MaterialPageRoute( builder: (context) => HomeScreen.fromBase64(res)));
      } 
      else{
        setState((){ 
          _isLoading = false;
          _error = "Loša kombinacija korisničkog imena/lozinke.";
        });
        passwordController.clear();
      }      
    }
    else
      return;
  }
}
