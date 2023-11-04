import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Post/PostComponentInstitution.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/models/DbModels/Category.dart';
import 'package:web_app/models/DbModels/City.dart';
import 'package:web_app/models/DbModels/Post.dart';
import 'package:web_app/models/ViewModels/PostFilterVM.dart';
import 'package:web_app/services/api/category.api.dart';
import 'package:web_app/services/api/city.api.dart';
import 'package:web_app/services/api/post.api.dart';

class InstitutionPostScreen extends StatefulWidget {
  @override
  _InstitutionPostScreenState createState() => _InstitutionPostScreenState();
}

class _InstitutionPostScreenState extends State<InstitutionPostScreen> {
  var _scrollController = new ScrollController(); //this scroll will listen to the list (where we are on the list)
  TextEditingController textCon = new TextEditingController();

  StreamController _postStreamController;
  Stream _stream;
  List<AppPost> _listOfPosts;
  bool _isLoading;

  int _counter;
  bool _challenges;
  bool _userPosts;
  bool _institutionPosts;
  int _cityID;
  int _categoryID;

  _initFilterValues()
  {
    _counter = 1; //1 x 5 posts fetch per http req
    _userPosts = false;
    _institutionPosts = false;
    _challenges = false;
    _cityID = loggedUser.headquaterID;
    _categoryID = -1; //do not filter by category
  }

  _filterPosts(bool challenges, bool userPosts, bool institutionPosts, int cityID, int categoryID) async
  {
    _challenges = challenges; _userPosts = userPosts; _institutionPosts = institutionPosts;
    _cityID = cityID; _categoryID = categoryID;

    PostFilterVM filter = new PostFilterVM(loggedUser.id, _cityID, _categoryID, _challenges, _userPosts, _institutionPosts, _counter);
    await PostAPIServices.getFilteredPosts(filter).then((value){
      _postStreamController.add(value);
      _listOfPosts = value;
    });
  }

  _setStream()
  {
    _postStreamController = new StreamController();
    _stream = _postStreamController.stream;
  }

  _loadPosts() async
  {
    PostFilterVM data = new PostFilterVM(loggedUser.id, _cityID, _categoryID, _challenges, _userPosts, _institutionPosts, _counter);
    await PostAPIServices.getFilteredPosts(data).then((value){
      _postStreamController.add(value);
      _listOfPosts = value;
    });
  }

  _handleRefresh() async
  {
    _counter += 1;
    PostFilterVM data = new PostFilterVM(loggedUser.id, _cityID, _categoryID, _challenges, _userPosts, _institutionPosts, _counter);
    await PostAPIServices.getFilteredPosts(data).then((value){
      _postStreamController.add(value);
      _listOfPosts = value;
    });
  }

  _addListenerToScrollController()
  {
    _scrollController.addListener(() async {

      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
        {
          setState(() => _isLoading = true);
          await _handleRefresh();
          setState(() => _isLoading = false);
        }
    });
  }

  _removePost(AppPost post)
  {
    _listOfPosts.remove(post);
    _postStreamController.add(_listOfPosts);
  }

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  } 
  
  @override
  void initState() {
    _initFilterValues();
    _isLoading = false;
    _setStream();
    _loadPosts();
    _addListenerToScrollController();
    
    super.initState();
  }


  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: <Widget>[
        makeHeader(),
        makePostView(),
      ]),
    );
  }

  Widget makePostView(){
    return Expanded(
      child: Container(
        child: Row(
          //alignment: Alignment.center,
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LeftSideMenu(_filterPosts),
            Expanded(
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                    return Container();
                  else
                    return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          //width: MediaQuery.of(context).size.width * 0.3,
                          //height: MediaQuery.of(context).size.height * 0.911,
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              makeNewPostField(),
                              for(int i=0; i<snapshot.data.length; i++)
                                PostComponentInstitution(snapshot.data[i], _removePost,  key: UniqueKey()),
                              _isLoading ?
                                BOTFunction.loadingIndicator() :
                                Container()
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeNewPostField(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        color: Colors.white
      ),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.175),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.005,
        vertical: MediaQuery.of(context).size.width * 0.003
      ),
      //height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            makeNewPostTextHeader(),
            makeTextField(),
            if(data != null) 
              makeOneImageView(),
            makeAddPictureButton(context),
          ],
        ),
      ),
    );
  }

  Container makeAddPictureButton(BuildContext _context){
    return Container(
      //width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.005,
        vertical: MediaQuery.of(context).size.width * 0.001,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[400]
          )
        )
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.002,
      ),
      child: Material(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              child: InkWell(
                hoverColor: Colors.grey[200],
                highlightColor: Colors.grey[200],
                onTap: (){
                  pickImage();
                },
                enableFeedback: false,
                child: Row(
                  children: [
                    Icon(MaterialCommunityIcons.image_outline, color: Colors.green,),
                    Text(
                      'Dodaj fotografiju',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.009
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.green,
              child: InkWell(
                hoverColor: Colors.green[700],
                splashColor: Colors.green[900],
                onTap: () async {
                  Post newPost = new Post.institutionPost(textCon.text, loggedUser.id, loggedUser.headquaterID, DateTime.now(), PostTypeEnum.institutionPost);
                  
                  showDialog(
                    context: _context,
                    builder: (context){
                      return LoadingDialog("Dodavanje objave...");
                    }
                  );

                  await PostAPIServices.addInstitutionPost(newPost, data != null ? base64.encode(data) : null)
                    .then((value){
                      if(value != null)
                      {
                        _listOfPosts.insert(0, value);
                        _postStreamController.add(_listOfPosts);

                        data = null;
                        textCon.text = "";
                      }
                      Navigator.pop(_context);
                    });

                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.002,
                    horizontal: MediaQuery.of(context).size.width * 0.003,
                  ),
                  child: Text(
                    'Dodaj',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.009
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget makeOneImageView(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.002,
            horizontal: MediaQuery.of(context).size.width * 0.002,
          ),
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.05,
          child: Image.memory(
            data,
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              data = null;
            });
          },
          child: Icon(MaterialCommunityIcons.close_circle_outline)
        )
      ],
    );
  }

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

        setState(() {
            name = input.files[0].name;
            data = base64.decode(stripped);
            error = null;
          });
          
      });
    });

    input.click();
  }

  Container makeTextField(){
    return Container(
      padding: EdgeInsets.only(
        bottom: 5.0,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Image.network(
            defaultServerURL + loggedUser.imageURL,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.width * 0.02,
            width: MediaQuery.of(context).size.height * 0.04,
          ),
          Expanded(
            child: TextField(
              controller: textCon,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                hintText: 'O čemu razmišljate?',
                // hoverColor: Colors.red,
                // fillColor: Colors.grey[300],
                filled: true,
                hoverColor: Colors.white,
                border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container makeNewPostTextHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.005,
        vertical: MediaQuery.of(context).size.width * 0.002,
      ),
      width: MediaQuery.of(context).size.width,
      child: Text(
        'Nova objava',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.009
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[400]))
      ),
    );
  }

  Widget makeHeader() {
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
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15.0,
                ),
                //makeFilterButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//--------------------------------------------


class LeftSideMenu extends StatefulWidget {
  final Function filterPosts;
  LeftSideMenu(this.filterPosts);
  @override
  _LeftSideMenuState createState() => _LeftSideMenuState();
}

class _LeftSideMenuState extends State<LeftSideMenu> {

  bool _challenges = false;
  bool _userPosts = false;
  bool _institutionPosts = false;
  City _selectedCity;
  MyCategory _selectedCategory;

  
  TextEditingController searchController = new TextEditingController();
  String searchString = '';

  List<City> cities = new List<City>();
    
  Future cityFuture;
  Future categoryFuture;

  _loadCities() async
  {
    return await CityAPIServices.getAllCities();
  }

  _loadCategories() async
  {
    return await CategoryAPIServices.getCategories();
  }

  _initFilterValues()
  {
    _userPosts = false;
    _institutionPosts = false;
    _challenges = false;
    _selectedCity = null;
    _selectedCategory = null;
  }

  @override
  void initState() {
    cityFuture = _loadCities();
    categoryFuture = _loadCategories();

    _initFilterValues();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //return makeBody(context); 
    return FutureBuilder(
      future: Future.wait([cityFuture, categoryFuture]),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Container();
        else
          return makeBody(context, snapshot.data[0], snapshot.data[1]);
      }
    );
  }

  Container makeBody(BuildContext context, List<City> cities, List<MyCategory> categories) {

    return Container(
    decoration: BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.grey[400],
          width: 1.2
        )
      ),
      color: Colors.white,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.006,
    ),
    width: MediaQuery.of(context).size.width * 0.18,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        createCityField(cities),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        makeChallengeCB(),
        makeUserCB(),
        makeInstitutionCB(),
        makeDropDownButton(categories),
        makeSubmitButton(),
      ],
    ),
  );
  }

  DropdownButton makeDropDownButton(List<MyCategory> categories) {
    return DropdownButton<MyCategory>(
      underline: Container(),
      icon: Icon(Icons.arrow_downward),
      iconSize: MediaQuery.of(context).size.width *0.015,
      iconEnabledColor: Colors.green[300],
      hint: Text('Izaberite kategoriju', style: TextStyle(color: Colors.black)),
      value: _selectedCategory,
      onChanged: (newValue) {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode()); 
          _selectedCategory = newValue;
        });
      },
      items: categories.map((data) {
        return DropdownMenuItem<MyCategory>(
          child: new Text(data.name),
          value: data,
        );
      }).toList(),
    );
  }

  Row makeInstitutionCB() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _institutionPosts,
          onChanged: (bool newValue){
            setState(() {
                _institutionPosts = newValue;
            });
          },
          activeColor: Colors.green[400], 
        ),
        Text('Objava institucije')
      ],
    );
  }

  Widget makeSubmitButton()
  {
    return RaisedButton(
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Text(
        'Uredi prikaz',
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.009,
          fontWeight: FontWeight.w500
        ),
      ),
      onPressed: (){
        widget.filterPosts(_challenges, _userPosts, _institutionPosts, _selectedCity != null ?  _selectedCity.id : loggedUser.headquaterID, _selectedCategory != null ? _selectedCategory.id : -1);
      },
    );
  }

  Row makeUserCB() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _userPosts,
          onChanged: (bool newValue){
            setState(() {
                _userPosts = newValue;
            });
          },
          activeColor: Colors.green[400], 
        ),
        Text('Korisnička objava')
      ],
    );
  }

  Row makeChallengeCB() {
    return Row(
      children: [
        Checkbox(
          value: _challenges,
          onChanged: (bool newValue){
            setState(() {
                _challenges = newValue;
            });
          },
          activeColor: Colors.green[400], 
        ),
        Text('Izazov'),
      ],
    );
  }

  Container makeSearchField() {
    return Container(
      child: Row(
        children: [
          Icon(Icons.search),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value;
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5.0),
                hintText: 'Unesite naslov za pretragu'),
            ),
          )
        ],
      )
    );
  }

  Widget createCityField(List<City> cities)
  {
    return DropdownButton<City>(
      hint: Text(
        loggedUser.headquaterName,
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

}
