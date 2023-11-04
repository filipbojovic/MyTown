import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Tiles/TilePostComponent.dart';
import 'package:web_app/components/other/ChangePasswordDialog.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/services/api/institution.api.dart';
import 'package:web_app/services/api/post.api.dart';

class InstitutionEditProfileScreen extends StatefulWidget {
  @override
  _InstitutionEditProfileScreenState createState() =>
      _InstitutionEditProfileScreenState();
}

class _InstitutionEditProfileScreenState
    extends State<InstitutionEditProfileScreen> {

      
  bool hasPicture;
  
  Future citiesFuture;
  Future postFuture;

  Uint8List uploadedImage;
  bool uploadedImageStarted = false;
  bool _enableChange = false;
  String option1Text;
  //List<City> fullListOfCities = new List<City>();

  TextEditingController password = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();

  String userPhone = loggedUser.phone;
  String userName = loggedUser.name;
  String userEmail = loggedUser.email;
  String userAddress = loggedUser.address;

  String errorText = "";

  _loadPosts() async {
    return await PostAPIServices.getAppPostsByUserID(loggedUser.id);
  }

  @override
  void initState() {
    super.initState();

    postFuture = _loadPosts();

    phoneCon.text = userPhone;
    nameCon.text = userName;
    emailCon.text = userEmail;
    addressCon.text = userAddress;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(color: Colors.white);
        else
          return Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [makeEditBox(), makePostsBox(snapshot.data)],
            ),
          );
      },
    );
  }
  Widget makePostsBox(List<AppPost> posts){
  return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.80,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.002,
        horizontal: MediaQuery.of(context).size.width * 0.002,
      ),
      decoration: BoxDecoration(
        color: Colors.white, border: Border.all(color: Colors.grey[400])
      ),
      child: GridView.builder(
        itemCount: posts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.0013,
          mainAxisSpacing: MediaQuery.of(context).size.height * 0.003,
          childAspectRatio: 5
        ),
        itemBuilder: (context, index) {
          return TilePostComponent(context, posts[index], null);
        }
      )
    );
  }

  Widget makeEditBox() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.004,
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white, border: Border.all(color: Colors.grey[400])
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          makeTitle(),
          makeProfileHeader(context),
          makeNameField(),
          makeAddressField(),
          makeEmailField(),
          makePhoneField(),
          if (errorText != "")
            Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
          makeAllButtons(context)
        ],
      )
    );
  }

  Widget makeTitle() {
    return Container(
        child: Text(
          'Profil',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.035,
            color: Colors.black,
          ),
        )
    );
  }

  Widget makeProfileHeader(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.004),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                makeProfilePhoto(context),
                SizedBox(width: MediaQuery.of(context).size.width * 0.003),
                Material(
                  child: InkWell(
                      enableFeedback: false,
                      onTap: () {
                        makeChangePhotoDialog(context);
                      },
                      child: Icon(MaterialCommunityIcons.camera)),
                ),
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Broj objava: ' + loggedUser.numOfPost.toString(),
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontSize: MediaQuery.of(context).size.width * 0.009),
                // ),
                Text(
                  "član od " +BOTFunction.formatDateDayMonthYear(loggedUser.joinDate),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.009),
                )
              ],
            )
          ],
        )
      );
  }

  ClipRRect makeProfilePhoto(BuildContext context) {
    return ClipRRect(
      child: data == null ? Image.network(
        defaultServerURL + loggedUser.imageURL,
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width * 0.08,
      ) :
      Image.memory(
        data,
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width * 0.08,
      ),
      borderRadius: BorderRadius.circular(10.0),
      // child: uploadedImageStarted ? Image.memory(
      //   data,
      //   fit: BoxFit.fill,
      //   width: MediaQuery.of(context).size.width * 0.08,
      // ) :
    );
  }

  Future makeChangePhotoDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[300],
            title: Text('Promeni profilnu sliku'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Izaberi sa radne površine'),
                  onTap: () async  {
                    await pickImage();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Ukloni sliku'),
                  onTap: () {
                    InstitutionAPIServices.deleteProfilePhoto(loggedUser.id);
                    setState(() {
                      loggedUser.setImageURL = defaultImageURL;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      );
  }

  Widget makeEmailField() {
    return Container(
      child: TextField(
        controller: emailCon,
        enabled: _enableChange,
        decoration: InputDecoration(
            labelText: "E-pošta",
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.030,
            ),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black)),
            focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black))),
      ),
    );
  }

  Widget makeAddressField() {
    return Container(
      child: TextField(
        controller: addressCon,
        enabled: _enableChange,
        decoration: InputDecoration(
            labelText: "Adresa",
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.030,
            ),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black)),
            focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black))),
      ),
    );
  }

  Widget makePhoneField() {
    return Container(
      child: TextField(
        controller: phoneCon,
        enabled: _enableChange,
        decoration: InputDecoration(
            labelText: "Broj telefona",
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.030,
            ),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black)),
            focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black))),
      ),
    );
  }

  Widget makeNameField() {
    return Container(
      child: TextField(
        controller: nameCon,
        enabled: _enableChange,
        decoration: InputDecoration(
            labelText: "Naziv",
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.030,
            ),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black)),
            focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black))),
      ),
    );
  }

  Widget makeAllButtons(BuildContext _context) {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_enableChange) makeChangePasswordButton(),
            if (_enableChange) makeGiveUpButton(),
            if (_enableChange) makeSaveDataButton(_context),
            if (!_enableChange) makeEditButton(),
          ],
        )
    );
  }

//---------------------------------------------
  Widget makeGiveUpButton() {
    return Material(
      child: InkWell(
        enableFeedback: false,
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.003,
              horizontal: MediaQuery.of(context).size.width * 0.005,
            ),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'Odustani',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.01,
                    color: Colors.black),
              )
            ),
        onTap: () {
          setState(() {
            nameCon.text = loggedUser.name;
            addressCon.text = loggedUser.address;
            emailCon.text = loggedUser.email;
            phoneCon.text = loggedUser.phone;
            _enableChange = false;
          });
        },
      ),
    );
  }

  Widget makeEditButton() {
    return Material(
      child: InkWell(
        enableFeedback: false,
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.003,
              horizontal: MediaQuery.of(context).size.width * 0.005,
            ),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'Izmeni',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                  color: Colors.black),
            )),
        onTap: () {
          setState(() {
            _enableChange = true;
          });
        },
      ),
    );
  }

  Widget makeChangePasswordButton() {
    return Material(
      child: InkWell(
        enableFeedback: false,
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.003,
              horizontal: MediaQuery.of(context).size.width * 0.005,
            ),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'Promeni lozinku',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                  color: Colors.black),
            )),
        onTap: () {
          showDialog(
              context: context, builder: (context) => ChangePasswordDialog());
        },
      ),
    );
  }

  Widget makeSaveDataButton(BuildContext _context) {
    return Material(
      child: InkWell(
        enableFeedback: false,
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.003,
              horizontal: MediaQuery.of(context).size.width * 0.005,
            ),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'Sačuvaj izmene',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                  color: Colors.black),
            )
          ),
          onTap: () async {
            var res = validateEdit(addressCon.text, emailCon.text, phoneCon.text);
            if (res) 
            {
              showDialog(
                context: _context,
                builder: (context){
                  return LoadingDialog("Izmena podataka u toku...");
                }
              );
              await InstitutionAPIServices.changeData(loggedUser.id, nameCon.text, addressCon.text, emailCon.text, phoneCon.text).then((value) 
              {
                if (!value)
                  setState(() => errorText = "Uneta e-mail adresa već postoji.");
                else
                {
                  loggedUser.setName = nameCon.text;
                  loggedUser.setAddress = addressCon.text;
                  loggedUser.setEmail = emailCon.text;
                  loggedUser.setPhone = phoneCon.text;
                  setState((){
                    _enableChange = false;
                    errorText = "";
                  });
                }
                Navigator.pop(_context);
              });
            }
          if (res) {
            setState(() {});
          }
        },
      ),
    );
  }

////----------------------------------------------
  String name = '';
  String error;
  Uint8List data;

  pickImage() {
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) async {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
        
        var value = await InstitutionAPIServices.changeProfilePhoto(loggedUser.id, stripped);
        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
          loggedUser.setImageURL = value;
        });
      });
    });

    input.click();
  }

  bool validateEdit(String addressValue, String email, String phoneNumber) {
    RegExp homePhoneRegExp = new RegExp(r'(^(0)[0-9]{2}[\/][0-9]{6,8}$)');
    RegExp phoneNumberRegExp = new RegExp(
        r'(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)');
    RegExp emailRegExp = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (!phoneNumberRegExp.hasMatch(phoneNumber) &&
        !homePhoneRegExp.hasMatch(phoneNumber)) {
      setState(() {
        errorText = "Unesite telefon u obliku 03x/xxxxxx ili 06x";
      });
      return false;
    } else if (!emailRegExp.hasMatch(email)) {
      setState(() {
        errorText = "Format e-mail adrese nije validan.";
      });
      return false;
    }
    return true;
  }
}
