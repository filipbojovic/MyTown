import 'package:flutter/material.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/models/DbModels/City.dart';
import 'package:web_app/models/DbModels/institution.dart';
import 'package:web_app/services/api/city.api.dart';
import 'package:web_app/services/api/institution.api.dart';

class CreateNewInstitution extends StatefulWidget {
  final BuildContext ctx;

  CreateNewInstitution(this.ctx);

  @override
  _CreateNewInstitutionState createState() => _CreateNewInstitutionState();
}

class _CreateNewInstitutionState extends State<CreateNewInstitution> {

  final TextEditingController password1Con = TextEditingController();
  final TextEditingController password2Con = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController cityCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController addressCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();
  City _selectedCity;
  Future _cityFuture;

  _getCities() async 
  {
    return await CityAPIServices.getAllCities();
  }

  @override
  void initState() {
    _cityFuture = _getCities();
    super.initState();
  }

  String error = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cityFuture,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Container();
        else
          return makeDialog(context, snapshot.data);
      },
    );
  }

  Dialog makeDialog(BuildContext context, List<City> cities) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title(),
            createName(),
            createEmail(),
            createPassword1(),
            createPassword2(),
            createAddressField(),
            createPhoneField(),
            createCityField(cities),
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
          'Dodaj novu instituciju',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontSize: 22),
        ),
      )
    );
  }

  Widget createPassword1() {
    return Container(
      child: TextField(
        controller: password1Con,
        obscureText: true,
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

  Widget createPassword2() {
    return Container(
      child: TextField(
        controller: password2Con,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Ponovite lozinku",
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

  Widget createEmail() {
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
        controller: nameCon,
        decoration: InputDecoration(
          labelText: "Naziv",
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

  Widget createAddressField(){
    return Container(
      child: TextField(
        controller: addressCon,
        decoration: InputDecoration(
          labelText: "Adresa",
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

  Widget createPhoneField(){
    return Container(
      child: TextField(
        controller: phoneCon,
        decoration: InputDecoration(
          labelText: "Telefon",
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

  Widget createCityField(List<City> cities)
  {
    return DropdownButton<City>(
      hint: Text(
        'Izaberite grad',
        style: TextStyle(color: Colors.black)
      ),
      value: _selectedCity,
      onChanged: (newValue) {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode()); 
          _selectedCity = newValue;
        });
      },
      items: cities.map((data) {
        return DropdownMenuItem<City>(
          child: new Text(data.name),
          value: data,
        );
      }).toList(),
    );
  }

  Widget sendDataButton() {
    return RaisedButton(
      child: Text(
        'Dodaj instituciju',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      onPressed: () async {
        if(!_validate(nameCon.text, password1Con.text, password2Con.text, emailCon.text, _selectedCity, phoneCon.text))
          return;
        
        Institution data = new Institution(nameCon.text, _selectedCity.id, emailCon.text, password1Con.text, addressCon.text, phoneCon.text, DateTime.now());
        showDialog(
          context: widget.ctx,
          barrierDismissible: false,
          child: LoadingDialog("Dodavanje institucije...")
        );

        await InstitutionAPIServices.addInstitution(data).then((value){
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

  bool _validate(String userName, String newPassword, String newPassword2, String email, City city, String phoneNumber)
  {
    RegExp name = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{2,}$');
    RegExp password = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    RegExp emailReg = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    RegExp homePhoneRegExp = new RegExp(r'(^(03)[0-9]{1}[\/][0-9]{6,8}$)');
    RegExp phoneNumberRegExp = new RegExp(r'(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)');

    if(!name.hasMatch(userName))
    {
      setState(() {
        error = "Neispravno ime";
      });
      return false;
    }
    else if(!password.hasMatch(newPassword))
    {
      setState(() {
        error = "Lozinka mora imati najmanje 8 karaktera, bar jednu cifru i veliko slovo.";
      });
      
      return false;
    }
    else if(newPassword != newPassword2)
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
    else if(city == null)
    {
      setState(() {
        error = "Izaberite grad.";
      });
      return false;
    }
    else if(!phoneNumberRegExp.hasMatch(phoneNumber) &&!homePhoneRegExp.hasMatch(phoneNumber)) {
      setState(() {
        error = "Unesite telefon u obliku 03x/xxxxxx ili 06x";
      });
      return false;
    }
    else
      return true;
  
  }
}
