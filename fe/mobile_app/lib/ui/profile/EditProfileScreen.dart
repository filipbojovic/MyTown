import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bot_fe/components/Other/LoadingDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppUser.dart';
import 'package:bot_fe/models/DbModels/City.dart';
import 'package:bot_fe/services/api/user.api.dart';
import 'package:bot_fe/services/picture.services.dart';
import 'package:bot_fe/ui/main/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EditProfile extends StatefulWidget {
  final List<City> cities;
  final AppUser user;

  EditProfile(this.user, this.cities);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); 

  _loadData()
  {
    firstNameCon.text = widget.user.firstName;
    lastNameCon.text = widget.user.lastName;
    cityCon.text = widget.user.city;
    emailCon.text = widget.user.email;
    cityID = widget.user.cityID;
    selectedCity = widget.cities
      .firstWhere((element) => element.id == widget.user.cityID);
  }

  @override
  void initState() {

      _loadData();
    super.initState();
  }

  /*@override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }*/

  final labelTextStyle = TextStyle(
    color: Colors.grey[500],
    fontSize: 18.0,
  );

  TextEditingController firstNameCon = TextEditingController();
  TextEditingController lastNameCon = TextEditingController();
  TextEditingController cityCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  int cityID;
  City selectedCity;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              bool validate = validateEdit(firstNameCon.text, lastNameCon.text, emailCon.text, selectedCity);
              if(validate == true)
              {
                var data = new Map<String, dynamic>();
                data["id"] = widget.user.id;
                data["firstName"] = firstNameCon.text;
                data["lastName"] = lastNameCon.text;
                data["email"] = emailCon.text;
                data["cityID"] = cityID;
                var res = await UserAPIServices.updateUserInfo(data);
                if(res)
                {
                  //data["city"] = cityCon.text;
                  //Navigator.pop(context, data);
                  Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => Profile(int.parse(loggedUserID), true)
                  ),
                  (route) => false);
                }
                else
                  BOTFunction.showSnackBar("Uneta e-mail adresa već postoji.", _scaffoldKey);
              }
            },
          )
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(MaterialCommunityIcons.close_circle_outline),
          onPressed: (){
            Navigator.pop(context);
          }
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text("Izmeni profil", style: TextStyle(color: Colors.grey[900]),),
      ),
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            makeProfilePhotoView(),
            Divider(
              color: Colors.black,
              height: 15.0,
            ),
            makeNameField(),
            makeLastNameField(),
            Container(
              child: makeAutoCompleteCityField(),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
            ),
            makeEmailField(),
          ],
        ),
      ),
    );
  }

  Container makeEmailField() {
    return Container(
      child: TextField(
        controller: emailCon,
        decoration: InputDecoration(labelText: "E-posta", labelStyle: labelTextStyle, 
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          )),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.0),
    );
  }

  AutoCompleteTextField<City> makeAutoCompleteCityField() {
    return AutoCompleteTextField<City>(
      decoration: InputDecoration(
        labelText: "Grad",
        labelStyle: labelTextStyle, 
        enabledBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: Colors.black)
          ),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: Colors.black
          )
        )
      ),
      controller: cityCon,
      itemSubmitted: (item) {
        setState(() {
          selectedCity=item;
          cityCon.text = item.name;
          cityID = item.id;
        });
      },
      clearOnSubmit: false,
      key: null,
      suggestions: widget.cities,
      itemBuilder: (context, item) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(item.name,
            style: TextStyle(
              fontSize: 16.0
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Text(item.id.toString())
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

  Container makeLastNameField() {
    return Container(
      child: TextField(
        controller: lastNameCon,
        //controller: lastName,
        decoration: InputDecoration(labelText: "Prezime", labelStyle: labelTextStyle, 
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          )),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.0),
    );
  }

  Container makeNameField() {
    return Container(
      child: TextField(
        controller: firstNameCon,
        decoration: new InputDecoration(
          labelText: "Ime", 
          labelStyle: labelTextStyle, 
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.black)
          )
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.0),
    
    );
  }

  Row makeProfilePhotoView() {
    print(defaultServerURL +loggedUser.profilePhotoURL);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        makeProfilePhoto(),
          IconButton(
            icon: Icon(Icons.photo_camera, size: 30.0, color: Colors.grey[900]),
            onPressed: (){
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                    backgroundColor: Colors.grey[300],
                    title: Text('Promeni profilnu sliku'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Nova slika'),
                          onTap: () async {
                            var image = await Picture.getImageFromCam();
                            if(image != null)
                            {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                child: LoadingDialog("Menjanje profilne slike..."),
                              );

                              await UserAPIServices.changeProfilePhoto(int.parse(loggedUserID), image).then((value){
                                Navigator.pop(context);
                                if(value == "422")
                                {
                                  BOTFunction.showSnackBar("Neispravan format slike. Slika može bili u .jpg, .jpeg ili .png formatu.", _scaffoldKey);
                                  return;
                                }
                                else
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile(widget.user.id, true)));
                              });
                            }
                          },
                        ),
                        ListTile(
                          title: Text('Izaberi iz galerije'),
                          onTap: () async {
                            var image = await Picture.getImageFromGallery();
                            {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                child: LoadingDialog("Menjanje profilne slike..."),
                              );
                              await UserAPIServices.changeProfilePhoto(int.parse(loggedUserID), image).then((value){
                                Navigator.pop(context);
                                if(value == "422")
                                {
                                  BOTFunction.showSnackBar("Neispravan format slike. Slika može bili u .jpg, .jpeg ili .png formatu.", _scaffoldKey);
                                  return;
                                }
                                else
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile(widget.user.id, true)));
                              });
                            }
                          },
                        ),
                        ListTile(
                          title: Text('Ukloni sliku'),
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              child: LoadingDialog("Brisanje profilne slike..."),
                            );
                            await UserAPIServices.deleteProfilePhoto(int.parse(loggedUserID));
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile(widget.user.id, true)));
                          },
                        ),
                      ],
                    ),
                  );
                }
              );
            },
          ),
      ],
    );
  }

  Widget makeProfilePhoto() {
    return CircleAvatar(
      backgroundImage: NetworkImage(defaultServerURL +loggedUser.profilePhotoURL),
      radius: MediaQuery.of(context).size.width * 0.13,
    );
  }

   bool validateEdit(String value1, String value2, String value3, City city){
    RegExp name=new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{2,}$');
    RegExp email=new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if(name.hasMatch(value1)){
      if(name.hasMatch(value2)){
        if(email.hasMatch(value3)){
          if(city!=null){
            return true;
          }
          else{
            BOTFunction.showSnackBar("Izaberite grad", _scaffoldKey);
            return false;
          }
        }
        else{
          BOTFunction.showSnackBar("Neispravna e-posta", _scaffoldKey);
          return false;
        }
      }
      else{
        BOTFunction.showSnackBar("Neispravno prezime", _scaffoldKey);
        return false;
      }
    }
    else{
      BOTFunction.showSnackBar("Neispravno ime", _scaffoldKey);
      return false;
    }
  }

}
