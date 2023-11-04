import 'package:flutter/material.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/DbModels/City.dart';
import 'package:web_app/services/api/city.api.dart';
import 'package:web_app/ui/ADMINISTRATOR/subpages/ChallengePostView.dart';
import 'package:web_app/ui/ADMINISTRATOR/subpages/InstitutionPostView.dart';
import 'package:web_app/ui/ADMINISTRATOR/subpages/UserPostView.dart';

class FilterController
{
  void Function(String filterText, int cityID, int postType) filterPosts;
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreen createState() => _PostScreen();
}

class _PostScreen extends State<PostScreen> {

  TextEditingController searchController = TextEditingController();
  FilterController _filterController = new FilterController();

  List<PostType> _postTypeList = List<PostType>();
  PostType _selectedType;
  var scrollCon = new ScrollController();
  City _selectedCity;
  Future _cityFuture;

  City _allCities;

  _loadCities() async
  {
    return await CityAPIServices.getAllCities();
  }

  _loadPostTypes() {
    _postTypeList.addAll([
      PostType("Izazov", 1),
      PostType("Korisnička objava", 2),
      PostType("Objava institucije", 3)
    ]);
  }

  @override
  void initState() {
    _loadPostTypes();
    _allCities = new City(-1, "Izaberite grad");
    _cityFuture = _loadCities();
    _selectedType = _postTypeList[1];
    super.initState();
  }


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
            cities.insert(0, _allCities);
          if(_selectedCity == null)
            _selectedCity = cities[0];
            
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(children: <Widget>[
                  makeHeader(snapshot.data),
                  if(_selectedType.typeID == PostTypeEnum.challengePost)
                    ChallengePostView(context, _filterController),
                  if(_selectedType.typeID == PostTypeEnum.userPost)
                    UserPostView(context, _filterController),
                  if(_selectedType.typeID == PostTypeEnum.institutionPost)
                    InstitutionPostView(context, _filterController),
                  ]
                ),
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
            color: themeColor,
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
              children: <Widget>[
                if(_selectedType.typeID != PostTypeEnum.userPost)
                  createCityField(cities),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                if(_selectedType.typeID != PostTypeEnum.userPost) 
                  Container(width: MediaQuery.of(context).size.width * 0.001,height: MediaQuery.of(context).size.height * 0.035, color: Colors.grey[500],),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                
                makePostTypeMenu(_postTypeList),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01)
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
        value: _selectedCity,
        onChanged: (newValue) {
          setState(() {
            FocusScope.of(context).requestFocus(new FocusNode()); 
            _selectedCity = newValue;
            _filterController.filterPosts(searchController.text, _selectedCity.id, _selectedType.typeID);
          });
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
        width: MediaQuery.of(context).size.width / 4,
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            onChanged: (value) {
              _filterController.filterPosts(value, _selectedCity.id, _selectedType._typeID);
            },
            controller: searchController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5.0),
                hintText: _selectedType.typeID == 1 ? 'Pretraga po naslovu ili imenu i prezimenu korisnika' : 'Pretraga po imenu i prezimenu korisnika',
                hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.008
                )
              ),
          ),
        )
      );
  }

  Widget makePostTypeMenu(List<PostType> _selections) {
    return DropdownButton<PostType>(
      underline: Container(),
      icon: Icon(Icons.arrow_downward),
      iconSize: MediaQuery.of(context).size.width *0.015,
      iconEnabledColor: Colors.green[300],
      value: _selectedType,
      onChanged: (newValue) {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectedType = newValue;
          _selectedCity = _allCities;
        });
      },
      items: _selections.map((data) {
        return DropdownMenuItem<PostType>(
          child: new Text(
            data.name,
            style: TextStyle(color: Colors.black),
          ),
          value: data,
        );
      }).toList(),
    );
  }
}

class PostType {
  String _name;
  int _typeID;

  String get name => _name;
  int get typeID => _typeID;

  PostType(this._name, this._typeID);
}
