import 'dart:core';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bot_fe/bottomNavBar.dart';
import 'package:bot_fe/components/Other/ConfirmDialog.dart';
import 'package:bot_fe/components/Other/LoadingDialog.dart';
import 'package:bot_fe/components/Other/PickLocationMap.dart';
import 'package:bot_fe/components/Other/PickerComponent.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/DbModels/City.dart';
import 'package:bot_fe/models/DbModels/Post.dart';
import 'package:bot_fe/models/DbModels/category.dart';
import 'package:bot_fe/services/api/category.api.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:bot_fe/services/api/city.api.dart';
import 'package:bot_fe/services/location.services.dart';
import 'package:bot_fe/services/picture.services.dart';
import 'package:bot_fe/ui/main/HomePageScreen.dart';
import 'package:bot_fe/ui/main/notification.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:location/location.dart' as gps;
import 'package:multi_image_picker/multi_image_picker.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  _NewPostState()
  {
    NotificationServices.selectedPage = 3;
    NotificationServices.notifController.pushToNotificationPage = _pushToNotifPage;
    NotificationServices.notifController.pushToLoginPage = _pushToLoginPage;
  }

  TextEditingController titleCon = new TextEditingController();
  TextEditingController descriptionCon = new TextEditingController();
  TextEditingController locationCon = new TextEditingController();
  TextEditingController cityCon = new TextEditingController();

  Future categoryFuture;
  Future cityFuture;
  DateTime _dateTime;
  String _location;
  String _error;
  bool isChallenge = false;
  Map<String, dynamic> locationData = new Map<String, dynamic>();
  FocusNode _cityFocus;

  List<Asset> images = List<Asset>();
  List<City> cities = new List<City>();
  List<MyCategory> list=new List<MyCategory>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var location = gps.Location(); //for location permission
  
  MyCategory selectedCategory;
  City _selectedCity;

  @override
  void initState() {
    _dateTime = DateTime.now();
    _selectedCity = new City(loggedUser.cityID, loggedUser.city);
    cityCon.text = _selectedCity.name;
    _error = "";
    _location = 'Učitaj lokaciju';
    _cityFocus = new FocusNode();
    categoryFuture = _loadCategories();
    cityFuture = _getCities();
    locationCon.text = _location.toString();

    super.initState();
  }
  _pushToNotifPage()
  {
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => UserNotification()
    ));
  }

   _pushToLoginPage() async
  {
    await showDialog(
      context: context,
      barrierDismissible: false,
      child: ConfirmDialog("Vaš nalog je obrisan od strane administratora. Za više informacija pošaljite e-mail na mojgrad.srb.rs@gmail.com.")
    );
    storage.delete(key: "jwt");
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => Login()
    ));
  }
  
  callBack(DateTime newDate)
  {
    setState(() => _dateTime = newDate);
  }

  _loadCategories() async 
  {
    return await CategoryAPIServices.getCategories();
  }

  _getCities() async
  {
    return await CityAPIServices.getAllCities();
  }

  _loadLocation() async
  {
    await Location.getLocation()
      .then((value){
        if(value == null)
          return;
        locationData["longitude"] = value["longitude"];
        locationData["latitude"] = value["latitude"];
        locationCon.text = locationData["textPosition"];
      });
  }

  makeDateFormat(DateTime date)
  {
    var dateString = date.day.toString() +"." +date.month.toString() +"." +date.year.toString();
    dateString += " " +date.hour.toString() +":" +date.minute.toString();
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([categoryFuture,cityFuture]),
      builder: (context, snapshot) 
      {
        if (!snapshot.hasData)
           return BOTFunction.loadingIndicator();
        else 
        {
          list = snapshot.data[0];
          cities = snapshot.data[1];
          return buildNewPost(snapshot.data[0],snapshot.data[1]);
        }
      },
    );
  }

  Widget buildNewPost(List<MyCategory> list, List<City> list1) {
    String formattedDate = makeDateFormat(_dateTime);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: myAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChallenge,
                  onChanged: (bool newValue){
                    setState(() {
                      isChallenge = newValue;
                    });
                  },
                  activeColor: Colors.green[400], 
                ),
                Text('Izazov')
              ],
            ),
            isChallenge ? createTitleField(titleCon) : Container(),
            createDescriptionField(descriptionCon),
            isChallenge ?  makeCityField() : Container(),
            if(isChallenge) makeLocationView(),
            isChallenge ? makeChallengeTimeLabel(formattedDate) : Container(),
            isChallenge ? makeTimePicker() : Container(),
            categoryAndPicture(list),
            images.length > 0 ? Picture.buildGridView(images) : Container(),
            if(_error != "") makeErrorField(),
            makeNewPostButton(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(2),
    );
  }

  Container makeCityField() {
    return Container(
      child: makeAutoCompleteCityField(),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.width * 0.015
      ),
    );
  }

  Container makeChallengeTimeLabel(String formattedDate) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.width * 0.015
      ),
      child: Text(
        "Rok za prihvatanje izazova: $formattedDate",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
      )
    );
  }

  Widget makeLocationView()
  {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.width * 0.005
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.width * 0.015
      ),
      child: Material(
        borderRadius: BorderRadius.circular(7.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(7.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: Colors.green, size: MediaQuery.of(context).size.width * 0.065),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.83,
                ),
                child: Text(
                  _location,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.04
                  ),
                ),
              )
            ],
          ),
          onTap: () async {
            
            if(isChallenge)
            {
              var permission = await location.hasPermission();
              var locationEnabled = await location.serviceEnabled();
              if(permission == gps.PermissionStatus.denied)
              {
                  BOTFunction.showSnackBar("Aplikacija zahteva dozvolu za korišćenje lokacije.", _scaffoldKey);
                  await location.requestPermission();
              }
              if(locationEnabled == false)
              {
                  BOTFunction.showSnackBar("Lokacija uređaja mora biti uključena da bi se postavio izazov.", _scaffoldKey);
                  await location.requestService();
              }
            }

            if(isChallenge && (await location.hasPermission() == gps.PermissionStatus.denied || await location.serviceEnabled() == false)) //after request dialog user pressed again DO NOT TURN LOCATION => terminate request
              return;
            if(isChallenge && locationData["latitude"] == null)
              await _loadLocation();

            var data = await showDialog(
              barrierDismissible: false,
              context: context,
              child: PickLocationMap(locationData["latitude"], locationData["longitude"], null)
            );

            var address = await Location.getFullAddress(data["latitude"], data["longitude"]);
            locationData["latitude"] = data["latitude"];
            locationData["longitude"] = data["longitude"];
            setState(() => _location = address.addressLine);
          },
        ),
      ),
    );
  }

  Container makeTimePicker() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: MediaQuery.of(context).size.width * 0.015
      ),
      child: PickerComponent(DateTime.now(), callBack),
    );
  }

  Container makeErrorField() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03
      ),
      child: Text(
        _error,
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: MediaQuery.of(context).size.width * 0.038
        ),
      ),
    );
  }

  Widget makeNewPostButton()
  {
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: RaisedButton(
          color: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          elevation: 0.0,
          onPressed: () async 
          {
              bool validate = validateNewPost(titleCon.text, descriptionCon.text, _selectedCity, selectedCategory, images.length);
              if(!validate)
                return;
              
              Post newPost = Post.withOutId(
                isChallenge ? titleCon.text : null,
                descriptionCon.text,
                int.parse(loggedUserID),
                DateTime.now(),
                isChallenge ? selectedCategory.id : null,
                _selectedCity.id,
                isChallenge ? locationData['latitude'] : null,
                isChallenge ? locationData['longitude'] : null,
                isChallenge ? _dateTime : null,
                isChallenge ? PostTypeEnum.challengePost : PostTypeEnum.userPost
              );
              
              showDialog(
                barrierDismissible: false,
                context: context,
                child: LoadingDialog("Postavljanje objave..."),
              );
              await ChallengeAPIServices.addChallengeWithPictures(newPost, images).then((value){
                Navigator.pop(context);

                if(value == "422")
                {
                  setState(() => _error = "Format slike nije podržan. Mogući formati su .jpg, .jpeg i .png.");
                  return;
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
              });
          },
          child: Text(
            isChallenge ? 'Dodaj izazov' : 'Dodaj objavu',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04
            ),
          ),
        ),
      ),
    );
  }

  Widget myAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2.0,
      centerTitle: true,
      title: Text(
        'Dodaj novu objavu',
        style: TextStyle(color: Colors.black, fontSize: 22.0),
      ),
    );
  }

  AutoCompleteTextField<City> makeAutoCompleteCityField() {
    return AutoCompleteTextField<City>(
      decoration: InputDecoration(
        hintText: 'Grad',
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            width: 0.0,
            style: BorderStyle.none
          )
        ),
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(8.0)
      ),
      controller: cityCon,
      focusNode: _cityFocus,
      itemSubmitted: (item) {
        setState(() {
          _selectedCity = item;
          cityCon.text = item.name;
        });
      },
      clearOnSubmit: false,
      onFocusChanged: (value){
        if(!value)
        {
          if(_selectedCity == null || _selectedCity.name != cityCon.text)
          {
            BOTFunction.showSnackBar("Morate izabrati neki od ponuđenih gradova.", _scaffoldKey);
            _cityFocus.requestFocus();
          }
        }
      },
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

  //title
  Widget createTitleField(TextEditingController title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.width * 0.015
      ),
      child: TextField(
        controller: title,
        decoration: new InputDecoration(
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              width: 0.0,
              style: BorderStyle.none
            )
          ),
          hintText: "Naslov",
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.all(8.0)
        ),
      )
    );
  }

  //description
  Widget createDescriptionField(TextEditingController description) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.width * 0.015
      ),
      child: TextField(  
        controller: description,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              width: 0.0,
              style: BorderStyle.none
            )
          ),
          filled: true,
          hintText: 'Opis',
          isDense: true,
          contentPadding: EdgeInsets.all(8.0),
        )
      ),
    );
  }

  //location field
  Widget createLocationField(TextEditingController locationCon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.width * 0.015
      ),
      child: TextField(
        scrollPhysics: ScrollPhysics(),
        controller: locationCon,
        //enabled: false,
        decoration: InputDecoration(
          fillColor: Colors.grey[300],
          border: InputBorder.none,
          filled: true,
          isDense: true,
          hintText: 'Lokacija',
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }
  
  Widget categoryAndPicture(List<MyCategory> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if(isChallenge) Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: createDropDownButton(list),
        ),
        FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Icon(Icons.camera_alt),
          onPressed: () {
            Picture.loadAssets(images, 3).then((value) {
              if (!mounted) return;
              setState(() {
                images = value;
              });
            });
          },
        ),
      ],
    );
  }

  //category
  DropdownButton createDropDownButton(List<MyCategory> _selections) {
    return DropdownButton<MyCategory>(
      hint: Text('Izaberite kategoriju', style: TextStyle(color: Colors.black)),
      value: selectedCategory,
      onChanged: (newValue) {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode()); 
          selectedCategory = newValue;
        });
      },
      items: _selections.map((data) {
        return DropdownMenuItem<MyCategory>(
          child: new Text(data.name),
          value: data,
        );
      }).toList(),
    );
  }

  Widget makeImageView(List<Asset> images)
  {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          return makeOneImageView(images[index], index);
        },
      ),
    );
  }

  Widget makeOneImageView(Asset image, int index){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.01,
          ),
          height: MediaQuery.of(context).size.height * 0.11,
          width: MediaQuery.of(context).size.width * 0.15,
          child: AssetThumb(
            asset: image,
            height: 300,
            width: 300,
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              images.removeAt(index);
            });
          },
          child: Icon(MaterialCommunityIcons.close_circle_outline)
        )
      ],
    );
  }

  bool validateNewPost(String title, String description, City city, MyCategory category, int imagesLength)
  {
    if(title == "" && isChallenge)
    {
      BOTFunction.showSnackBar("Unesite naslov izazova.", _scaffoldKey);
      return false;
    }
    else if(description == "")
    {
      BOTFunction.showSnackBar("Unesite opis objave.", _scaffoldKey);
      return false;
    }
    else if(city == null && isChallenge)
    {
      BOTFunction.showSnackBar("Izaberite grad.", _scaffoldKey);
      return false;
    }
    else if(isChallenge && _selectedCity.name != cityCon.text.trim())
    {
      BOTFunction.showSnackBar("Izaberite grad koji postoji u listi.", _scaffoldKey);
      return false;
    }
    else if(isChallenge && category == null)
    {
      BOTFunction.showSnackBar("Izaberite kategoriju.", _scaffoldKey);
      return false;
    }
    else if(isChallenge && imagesLength < 1)
    {
      BOTFunction.showSnackBar("Izaberite bar jednu sliku.", _scaffoldKey);
      return false;
    }
    else if(isChallenge && locationData["latitude"] == null)
    {
      BOTFunction.showSnackBar("Izaberite lokaciju izazova.", _scaffoldKey);
      return false;
    }
    else if(isChallenge && _dateTime.difference(DateTime.now().add(Duration(minutes: -2))).inDays < 1)
    {
      BOTFunction.showSnackBar("Izazov mora trajati najmanje jedan dan.", _scaffoldKey);
      return false;
    }
    else
      return true;
  }
}
