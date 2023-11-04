import 'dart:convert';
import 'package:bot_fe/components/Other/ForgottenPasswordDialog.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:bot_fe/ui/main/HomePageScreen.dart';
import 'package:bot_fe/ui/sub_pages/LoadingScreen.dart';
import 'package:bot_fe/ui/sub_pages/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:bot_fe/config/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var storage = FlutterSecureStorage();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: _isLoading? LoadingScreen(): ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            makeEmailField(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            makePasswordField(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            makeForgottenPasswordButton(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            makeLoginButton(),
            SizedBox(height: 5.0),
            makeFirstTimeLabel(context),
          ],
        ),
      )
    );
  }

  Container makeForgottenPasswordButton(BuildContext context) {
    return Container( //-----------------forgotPASSWORD-----------------
      alignment: Alignment(1.0, 0.0),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.002),
      child: InkWell(
        child: Text('Zaboravljena lozinka?', style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold),),
        onTap: () {
          showDialog(
            context: context,
            child: ForgottenPasswordDialog()
          );
        },
      ),
    );
  }

  Row makeFirstTimeLabel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Prvi put ste ovde? ', style: TextStyle(color: Colors.grey[700]),),
        SizedBox(width: 5.0,),
        InkWell(
          child: Text('Registrujte se', style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
          },
        ),
      ],
    );
  }

  Widget makeLoginButton()
  {
    return RaisedButton(
      onPressed: () async {
        setState(() => _isLoading = true);

        var res = await UserAPIServices.userLogin(emailController.text.trim(), passwordController.text);

        if(res != null)
        {
          res = res.substring(1, res.length - 1);
          storage.write(key: "jwt", value: res);
          setState(() => _isLoading = false);

          var jwtParts = res.split(".");
          var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwtParts[1]))));
          loggedUser = await UserAPIServices.getAppUserByID(int.parse(payload['nameid']));
          loggedUserID = payload['nameid'];
          print(loggedUserID);
          NotificationServices.setUpNotifications();

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        else
        {
          setState(() => _isLoading = false);
          print('wrong email/password');
          BOTFunction.showSnackBar("Pogresna e-posta/lozinka", _scaffoldKey);
          passwordController.clear();
        }
      },
      color: Colors.green[600],
      textColor: Colors.white,
      child: Text('Prijavite se', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
    );
  }

  Widget makeEmailField()
  {
    return Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[700])),
    ),
    child: TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.email, color: Colors.green[600],),
        hintText: "E-mail adresa",
      ),
    ),
  );
  }

  Widget makePasswordField()
  {
     return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[700])),
      ),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.lock, color: Colors.green[600],),
          hintText: 'Lozinka'
        ),
      ),
    );
  }

  final logo = Container(
    height: 250,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(logoPath),
        fit: BoxFit.contain
      )
    ),
  );
}