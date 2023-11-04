import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bot_fe/components/Other/LoadingDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/DbModels/City.dart';
import 'package:bot_fe/models/DbModels/User.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final TextEditingController firstNameC = new TextEditingController();
  final TextEditingController lastNameC = new TextEditingController();
  final TextEditingController emailC = new TextEditingController();
  final TextEditingController passwordC = new TextEditingController();
  final TextEditingController newPasswordC = new TextEditingController();
  final TextEditingController cityC = TextEditingController();
  final TextEditingController day = new TextEditingController();
  final TextEditingController month = new TextEditingController();
  final TextEditingController year = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int ind=0;
  List<City> cities = new List<City>();
  City selectedCity;
  int _radioValue = -1;
  FocusNode _cityFocus;
  FocusNode _monthFocus;
  FocusNode _yearFocus;

  void getCities() async{
    var res = await get(serverURL +defaultCityURL);
    var citiesObject = jsonDecode(res.body);
    for (var item in citiesObject) {
      cities.add(City.fromObject(item));
    }
  }

  @override
  void initState(){
    getCities();
    _cityFocus = new FocusNode();
    _monthFocus = new FocusNode();
    _yearFocus = new FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    
    firstNameC.clear(); lastNameC.clear(); emailC.clear();
    passwordC.clear(); newPasswordC.clear(); cityC.clear();
    day.clear(); month.clear(); year.clear();

    super.dispose();
  }

  final logo = Container(
    height: 200,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(logoPath),
        fit: BoxFit.contain
      )
    ),
  );

  Widget makeFirstNameField()
  {
    return Container( //ovo je email
      padding: EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[700])),
      ),
      child: TextFormField(
        controller: firstNameC,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.person, color: Colors.green[600],),
          hintText: "Ime",
        ),
      ),
    );
  }

  Widget makeLastNameField()
  {
    return Container( //ovo je email
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[700])),
      ),
      child: TextFormField(
        controller: lastNameC,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.person, color: Colors.green[600],),
          hintText: "Prezime",
        ),
      ),
    );
  }

  Widget makeEmailField()
  {
    return Container( //ovo je email
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[700])),
      ),
      child: TextFormField(
        controller: emailC,
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
        controller: passwordC,
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.lock, color: Colors.green[600],),
          hintText: 'Lozinka'
        ),
      ),
    );
  }

  Widget makeSecondPasswordField()
  {
    return Container( 
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[700])),
      ),
      child: TextFormField(
        controller: newPasswordC,
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.lock, color: Colors.green[600],),
          hintText: 'Ponovi lozinku'
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 15.0, left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            makeFirstNameField(),
            makeLastNameField(),
            makePasswordField(),
            makeSecondPasswordField(),
            makeEmailField(),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[700])),
              ),
              child: makeAutoCompleteCityField(),
              padding: EdgeInsets.all(8.0),
            ),
            makeBirthAndGenderFields(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                makeRegistrationButton(),
                makeGoBackButton(context),
              ],
            ),
            SizedBox(height: 1.0),
          ],
        ),
      )
    );
  }

  RaisedButton makeGoBackButton(BuildContext context) {
    return RaisedButton( //----------------------GO BACK BUTTON-------------------------
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.grey[700],
      textColor: Colors.white,
      child: Text(
        'Nazad',
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13.0))),
    );
  }

  Widget makeRegistrationButton()
  {
    return RaisedButton( //--------------------REGISTER BUTTON------------------
      onPressed: () async {
        bool validate = validateRegistration(firstNameC.text, lastNameC.text, passwordC.text, newPasswordC.text, emailC.text, selectedCity);
        if(validate)
        {
          var birthDate = DateTime.utc(int.parse(year.text), int.parse(month.text), int.parse(day.text));
          User user = new User.withOutId(firstNameC.text, lastNameC.text, emailC.text, selectedCity.id, birthDate, _radioValue, DateTime.now());

          showDialog(
            context: context,
            barrierDismissible: false,
            child: LoadingDialog("Registracija u toku...")
          );
          await UserAPIServices.registerNewUser(user, passwordC.text)
            .then((value) {
              Navigator.pop(context);
              if(value == "409")
                  BOTFunction.showSnackBar("Već postoji korisnik sa datom email adresom.", _scaffoldKey);
              else if(value == "404")
                BOTFunction.showSnackBar("Došlo je do greške. Proverite internet konekciju.", _scaffoldKey);
              else
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: successfullRegistrationDialog(context)
                );
            });
        }
      },
      color: Colors.green[600],
      textColor: Colors.white,
      child: Text(
        'Registrujte se',
        style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.04
        )
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13.0))),
    );
  }

  AlertDialog successfullRegistrationDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      content: Text('Uspešno ste se registrovali. Bićete preusmereni na stranu za prijavu.'),
      actions: [
        FlatButton(
          child: Text(
            'U redu',
            style: TextStyle(
              color: Colors.green
            ),
          ),
          onPressed: (){
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
          },
        )
      ],
    );
  }

  Widget makeBirthAndGenderFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        makeGenderField(),
        makeBirthField()
      ],
    );
  }

  Widget makeBirthField() {
    return Column(
      children: [
        Text(
          'Datum rođenja:',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01
              ),
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.03,
              child: TextField(
                controller: day,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2)
                ],
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035
                ),
                onChanged: (value){
                  if(value.length == 2)
                    _monthFocus.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: 'dan',
                  hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03
                  )
                )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01
              ),
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.03,
              child: TextField(
                focusNode: _monthFocus,
                controller: month,
                keyboardType: TextInputType.number,
                onChanged: (value){
                  if(value.length == 2)
                    _yearFocus.requestFocus();
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2)
                ],
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035
                ),
                decoration: InputDecoration(
                  hintText: 'mesec',
                  hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03
                  )
                )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01
              ),
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.03,
              child: TextField(
                focusNode: _yearFocus,
                controller: year,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4)
                ],
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035
                ),
                decoration: InputDecoration(
                  hintText: 'godina',
                  hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03
                  )
                )
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column makeGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          'Pol:',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05
          ),
        ),
        Row(
          children: [
            Radio(
              value: 1,
              groupValue: _radioValue,
              onChanged: (int value) {
                setState(() {
                  _radioValue = value;
                });
              },
            ),
            Text('Muški')
          ],
        ),
        Row(
          children: [
            Radio(
              value: 2,
              groupValue: _radioValue,
              onChanged: (int value) {
                setState(() {
                  _radioValue = value;
                });
              },
            ),
            Text('Ženski')
          ],
        )
      ],
    );
  }

  AutoCompleteTextField<City> makeAutoCompleteCityField() {
    return AutoCompleteTextField<City>(
      decoration: InputDecoration(
        hintText: 'Grad', 
        icon: Icon(Icons.location_city, color: Colors.green[600],),
        border: InputBorder.none,
      ),
      controller: cityC,
      focusNode: _cityFocus,
      itemSubmitted: (item) {
        setState(() {
          cityC.text = item.name;
          selectedCity=item;
        });
      },
      onFocusChanged: (value){
        if(!value)
        {
          if(selectedCity == null || selectedCity.name != cityC.text)
          {
            BOTFunction.showSnackBar("Morate izabrati neki od ponuđenih gradova.", _scaffoldKey);
            _cityFocus.requestFocus();
          }
        }
      },
      clearOnSubmit: false,
      key: null,
      suggestions: cities,
      itemBuilder: (context, item) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(item.name,
            style: TextStyle(
              fontSize: 16.0
              ),
            ),
          ],
        );
      },
      itemSorter: (a, b) {
        return a.name.compareTo(b.name);
      },
      itemFilter: (item, query) {
          return item.name
            .toLowerCase()
            .startsWith(query.toLowerCase());
        }
    );
  }

  bool validateRegistration(String firstName, String lastName, String newPassword, String newPassword2, String email, City city){
    RegExp name = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{2,}$');
    RegExp password = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    RegExp emailReg = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if(!name.hasMatch(firstName))
    {
      BOTFunction.showSnackBar("Neispravno ime.", _scaffoldKey);
      return false;
    }
    else if(!name.hasMatch(lastName))
    {
      BOTFunction.showSnackBar("Neispravno prezime.", _scaffoldKey);
      return false;
    }
    else if(!password.hasMatch(newPassword))
    {
      BOTFunction.showSnackBar("Lozinka mora imati najmanje 8 karaktera, bar jednu cifru i veliko slovo.", _scaffoldKey);
      return false;
    }
    else if(newPassword != newPassword2)
    {
      BOTFunction.showSnackBar("Lozinke se ne poklapaju.", _scaffoldKey);
      return false;
    }
    else if(!emailReg.hasMatch(email))
    {
      BOTFunction.showSnackBar("Neispravna email adresa.", _scaffoldKey);
      return false;
    }
    else if(city == null)
    {
      BOTFunction.showSnackBar("Izaberite grad.", _scaffoldKey);
      return false;
    }
    else if(_radioValue == -1)
    {
      BOTFunction.showSnackBar("Izaberite pol.", _scaffoldKey);
      return false;
    }
    else if(day.text == "" || int.parse(day.text) < 1 || int.parse(day.text) > 31)
    {
      BOTFunction.showSnackBar("Dan rođenja može biti u opsegu od 1 do 31.", _scaffoldKey);
      return false;
    }
    else if(month.text == "" || int.parse(month.text) < 1 || int.parse(month.text) > 12)
    {
      BOTFunction.showSnackBar("Mesec rođenja može biti u opsegu od 1 do 12.", _scaffoldKey);
      return false;
    }
    else if(year.text == "" || int.parse(year.text) < 1920 || int.parse(year.text) > 2010)
    {
      BOTFunction.showSnackBar("Godina rođenja može biti u opsegu od 1920 do 2010.", _scaffoldKey);
      return false;
    }
    else
      return true;
  }
}
