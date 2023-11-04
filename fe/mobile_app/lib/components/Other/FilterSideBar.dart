import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/DbModels/category.dart';
import 'package:bot_fe/services/api/city.api.dart';
import 'package:flutter/material.dart';
import 'package:bot_fe/models/DbModels/City.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class FilterSideBar extends StatefulWidget {
  
  final Function filterPosts;
  final bool challenges;
  final bool userPosts;
  final bool institutionPosts;
  final int cityID;
  final int categoryID;
  final String cityName;
  FilterSideBar(this.filterPosts, this.challenges, this.userPosts, this.institutionPosts, this.cityID, this.categoryID, this.cityName);
  
  @override
  _FilterSideBarState createState() => _FilterSideBarState();
}

class _FilterSideBarState extends State<FilterSideBar> {

  TextEditingController cityCon = new TextEditingController();
  List<City> cities = new List<City>();
  Future cityFuture;
  
  bool _challenges;
  bool _userPosts;
  bool _institutionPosts;
  int _cityID;
  String _cityName;
  City _selectedCity;
  MyCategory _selectedCategory;
  FocusNode _cityFocus;
  String _error;

  _initFilterValues()
  {
    _userPosts = widget.userPosts;
    _institutionPosts = widget.institutionPosts;
    _challenges = widget.challenges;
    _cityID = widget.cityID;
    cityCon.text = _cityName = widget.cityName;
  }

  _getCities() async
  {
    return await CityAPIServices.getAllCities();
  }

  @override
  void initState() {
    cityFuture = _getCities();
    _error = "";
    _cityFocus = new FocusNode();
    _initFilterValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cityFuture,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Container();
        else
        {
          cities = snapshot.data;
          _selectedCity = cities.firstWhere((element) => element.id == _cityID);
          return makeDrawer();
        }
      },
    );
  }

  Drawer makeDrawer() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          children: <Widget>[
            if(_error != "") Container(
              child: makeErrorField(),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            ),
            Container(
              child: makeAutoCompleteCityField(),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            ),
            CheckboxListTile(
              activeColor: Colors.green,
              title: Text("Prikaži izazove", style: TextStyle(fontSize: 15.0)),
              onChanged: (bool newValue){
                setState(() => _challenges = newValue);
              },
              value: _challenges,
            ),
            CheckboxListTile(
              activeColor: Colors.green,
              title: Text("Prikaži objave institucije", style: TextStyle(fontSize: 15.0)),
              onChanged: (bool newValue){
                setState(() => _institutionPosts = newValue);
              },
              value: _institutionPosts,
            ),
            CheckboxListTile(
              activeColor: Colors.green,
              title: Text("Prikaži korisničke objave", style: TextStyle(fontSize: 15.0)),
              onChanged: (bool newValue){
                setState(() => _userPosts = newValue);
              },
              value: _userPosts,
            ),
            makeSubmitButton()
          ],
        ),
      ),
    );
  }

  Widget makeErrorField()
  {
    return Text(
      _error,
      style: TextStyle(
        color: Colors.red,
        fontSize: MediaQuery.of(context).size.width * 0.035,
        fontWeight: FontWeight.w500
      ),
    );
  }

  AutoCompleteTextField<City> makeAutoCompleteCityField() {
    return AutoCompleteTextField<City>(
      focusNode: _cityFocus,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            width: 0.0,
            style: BorderStyle.none
          )
        ),
        fillColor: Colors.grey[300],
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(8.0)
      ),
      controller: cityCon,
      itemSubmitted: (item) {
        setState(() {
          _selectedCity = item;
          _cityID = item.id;
          cityCon.text = item.name;
        });
      },
      onFocusChanged: (value){
        if(!value)
        {
          if(_selectedCity == null || _selectedCity.name != cityCon.text)
          {
            setState(() => _error ="Polje mora sadržati naziv nekog od ponuđenih gradova.");
            _cityFocus.requestFocus();
          }
          else
            setState(() => _error = "");
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
              fontSize: MediaQuery.of(context).size.width * 0.045
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

  Widget makeSubmitButton()
  {
    return Container(
      child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Text(
          'Uredi prikaz',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w500
          ),
        ),
        onPressed: (){

          if(_selectedCity == null || _selectedCity.name != cityCon.text)
          {
            setState(() => _error ="Polje mora sadržati naziv nekog od ponuđenih gradova.");
            _cityFocus.requestFocus();
            return;
          }

          widget.filterPosts(_challenges, _userPosts, _institutionPosts, _cityID, _selectedCategory != null ? _selectedCategory.id : -1, _selectedCity != null ? _selectedCity.name : _cityName);
          Navigator.pop(context);
        },
      ),
    );
  }

}
