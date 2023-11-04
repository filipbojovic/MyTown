import 'package:flutter/material.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/models/DbModels/Administrator.dart';
import 'package:web_app/services/api/administrator.api.dart';

class CreateNewAdministrator extends StatefulWidget {
  final BuildContext ctx;
  CreateNewAdministrator(this.ctx);

  @override
  _CreateNewAdministratorState createState() => _CreateNewAdministratorState();
}

class _CreateNewAdministratorState extends State<CreateNewAdministrator> {
  final TextEditingController usernameCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();
  final TextEditingController password2Con = TextEditingController();
  final TextEditingController emailCon = TextEditingController();

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title(),
            createName(),
            createEmailField(),
            createPassword(),
            createPassword2(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.004),
            sendDataButton(),
            if(error != "")
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Container(
        child: Text(
          'Dodaj novog administratora',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.012),
        ),
      )
    );
  }

  Widget createPassword() 
  {
    return Container(
      child: TextField(
        obscureText: true,
        controller: passwordCon,
        decoration: InputDecoration(
          labelText: "Lozinka",
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.009,
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          )
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal:25),
    );
  }

  Widget createPassword2() 
  {
    return Container(
      child: TextField(
        obscureText: true,
        controller: password2Con,
        decoration: InputDecoration(
          labelText: "Lozinka",
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.009,
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          )
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal:25),
    );
  }

  Widget createEmailField()
  {
    return Container(
      child: TextField(
        controller: emailCon,
        decoration: InputDecoration(
          labelText: "E-mail",
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.009,
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          )
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal:25),
    );
  }

  Widget createName() {
    return Container(
      child: TextField(
        controller: usernameCon,
        decoration: InputDecoration(
          labelText: "Korisničko ime",
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.009,
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          )
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal:25),
    );
  }

  Widget sendDataButton() {
    return RaisedButton(
      child: Text(
        'Dodaj administratora',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      onPressed: () async {
        if(!_validate(usernameCon.text, passwordCon.text, password2Con.text, emailCon.text))
          return;
        
        Administrator data = new Administrator(usernameCon.text, emailCon.text, DateTime.now(), passwordCon.text);
        showDialog(
          context: widget.ctx,
          barrierDismissible: false,
          child: LoadingDialog("Dodavanje administratora...")
        );

        await AdministratorAPIServices.addAdministrator(data).then((value){
          Navigator.pop(widget.ctx);
          if(value == "409")
          {
            setState(() => error = "Već postoji korisnik sa ovom e-mail adresom.");
            return;
          }
          else if(value == "400")
          {
            setState(() => error = "Došlo je do greške. Proverite internet konekciju.");
            return;
          }
          else
            Navigator.pop(widget.ctx, value);
        });
      },
    );
  }

  bool _validate(String userName, String newPassword1, String newPassword2, String email){
    RegExp name = new RegExp(r'^(?=.*?([A-Z]|[a-z]))(?=.*?[a-z]).{2,}$');
    RegExp password = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    RegExp emailReg = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if(!name.hasMatch(userName))
    {
      setState(() {
         error = 'Neispravno ime';
      
      });
     return false;
    }
    else if(!password.hasMatch(newPassword1))
    {
      setState(() {
        error = "Lozinka mora imati najmanje 8 karaktera, bar jednu cifru i veliko slovo.";
      
      });
      return false;
    }
    else if(newPassword1 != newPassword2)
    {
      setState(() {
        error = "Lozinke se ne poklapaju.";
      
      });
      return false;
    }
    else if(!emailReg.hasMatch(email))
    {
      setState(() {
        error = "Neispravna email adresa.";
      
      });
      return false;
    }
    else
      return true;
  }
}
