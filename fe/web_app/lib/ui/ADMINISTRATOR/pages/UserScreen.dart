import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/DbModels/City.dart';
import 'package:web_app/services/api/city.api.dart';
import 'package:web_app/ui/ADMINISTRATOR/subpages/AdministratorView.dart';
import 'package:web_app/ui/ADMINISTRATOR/subpages/InstitutionView.dart';
import 'package:web_app/ui/ADMINISTRATOR/subpages/UserView.dart';
class UserFilter
{
  void Function(String filterText, int cityID) filterUsers;
  void Function(String filterText) filterAdmins;
  void Function(String filterText, int cityID) filterInstitutions;
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreen createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {

  UserType _selectedType;
  List<UserType> _userTypeList = new List<UserType>();
  UserFilter _filterController = new UserFilter();

  TextEditingController searchController = new TextEditingController();
  String searchString = '';
  City _selectedCity;
  Future _cityFuture;

  _loadCities() async
  {
    return await CityAPIServices.getAllCities();
  }

  _loadUserTypes()
  {
    _userTypeList.addAll([
      UserType("Građanin", 1),
      UserType("Institucija", 2),
      UserType("Administrator", 3)
    ]);
  }

  @override
  void initState() {
    super.initState();
    _cityFuture = _loadCities();
    _loadUserTypes();
    
    setState(() {
      searchString = searchController.text;
      _selectedType = _userTypeList[0];
    });
  }
  
  var scrollCon = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cityFuture,
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          return BOTFunction.loadingIndicator();
        else
        {
          List<City> cities = snapshot.data;
          if(cities[0].id != -1)
            cities.insert(0, new City(-1, "Izaberite grad"));
          if(_selectedCity == null)
            _selectedCity = cities[0];
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                makeHeader(cities),
                if(_selectedType == _userTypeList[0])
                  UserView(_filterController),
                if(_selectedType == _userTypeList[1])
                  InstitutionView(_filterController),
                if(_selectedType == _userTypeList[2])
                  AdministratorView(_filterController)
              ]
            ),
          );
        }
      }
    );
  }

  Widget makeHeader(List<City> cities) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 0.1, // has the effect of softening the shadow
            spreadRadius: 1.0 // has the effect of extending the shadow
          )
        ],
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              makeSearchField(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                if(_selectedType.typeID != 3)
                  createCityField(cities),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                if(_selectedType.typeID != 3)
                  Container(width: MediaQuery.of(context).size.width * 0.001,height: MediaQuery.of(context).size.height * 0.035, color: Colors.grey[500],),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                makeUserTypeMenu(_userTypeList),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createCityField(List<City> cities)
  {
    return Container(
      // padding: EdgeInsets.symmetric(
      //   horizontal: MediaQuery.of(context).size.width * 0.002,
      //   vertical: MediaQuery.of(context).size.width * 0.001
      // ),
      // decoration: ShapeDecoration(
      //   color: themeColor,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(7.0)),
      //   ),
      // ),
      child: DropdownButton<City>(
        underline: Container(),
        icon: Icon(Icons.arrow_downward),
        iconSize: MediaQuery.of(context).size.width *0.015,
        iconEnabledColor: Colors.green[300],
        // hint: Text(
        //   "Izaberite grad",
        //   style: TextStyle(color: Colors.black)
        // ),
        value: _selectedCity,
        onChanged: (newValue) 
        {
          setState(() {
            FocusScope.of(context).requestFocus(new FocusNode()); 
            _selectedCity = newValue;
          });

          if(_selectedType.typeID == 1)
            _filterController.filterUsers(searchController.text, _selectedCity.id);
          else if(_selectedType.typeID == 3)
            _filterController.filterAdmins(searchController.text);
          else
            _filterController.filterInstitutions(searchController.text, _selectedCity.id);

        },
        items: cities.map((data) {
          return DropdownMenuItem<City>(
            child: new Text(data.name),
            value: data,
          );
        }).toList(),
      ),
    );
  }

  Container makeSearchField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      child: new ListTile(
        leading: new Icon(Icons.search),
        title: new TextField(
          onChanged: (value) {
            if(_selectedType.typeID == 1)
              _filterController.filterUsers(value, _selectedCity.id);
            else if(_selectedType.typeID == 3)
              _filterController.filterAdmins(value);
            else
              _filterController.filterInstitutions(value, _selectedCity.id);
          },
          controller: searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5.0),
            hintText: _selectedType.typeID == 1 ? 'ime i prezime korisnika' : (_selectedType.typeID == 2 ? "naziv institucije" : "korisničko ime"),
            hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.010
                )
          ),
        ),
      )
    );
  }

  Widget makeUserTypeMenu(List<UserType> _selections) {
    return DropdownButton<UserType>(
      underline: Container(),
      icon: Icon(Icons.arrow_downward),
      iconSize: MediaQuery.of(context).size.width *0.015,
      iconEnabledColor: Colors.green[300],
      value: _selectedType, //--------------------------
      onChanged: (newValue) {
          setState(() {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectedType = newValue;
          }
        );
      },
        items: _selections.map((data) {
          return DropdownMenuItem<UserType>(
            value: data,
            child: new Text(
              data.name,
              style: TextStyle(color: Colors.black),
            ),
          );
        }
      ).toList(),
    );
  }

}

class UserType {
  String _name;
  int _typeID;

  String get name => _name;
  int get typeID => _typeID;

  UserType(this._name, this._typeID);
}
