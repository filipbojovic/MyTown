import 'dart:async';
import 'package:bot_fe/bottomNavBar.dart';
import 'package:bot_fe/components/Other/ConfirmDialog.dart';
import 'package:bot_fe/components/Other/FilterSideBar.dart';
import 'package:bot_fe/components/PostComponents/ChallengePostComponent.dart';
import 'package:bot_fe/components/PostComponents/UserPostComponent.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/models/ViewModels/PostFilterVM.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/api/post.api.dart';
import 'package:bot_fe/ui/main/notification.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _HomePageState()
  {
    NotificationServices.selectedPage = 0;
    NotificationServices.notifController.pushToNotificationPage = _pushToNotifPage;
    NotificationServices.notifController.pushToLoginPage = _pushToLoginPage;
  }

  var _scrollController = new ScrollController(); //this scroll will listen to the list (where we are on the list)
  StreamController _postStreamController;
  Stream _stream;
  List<AppPost> _listOfPosts;
  List<AppPost> filteredListOfPosts = [];

  bool _isLoading;
  int _counter;
  bool _challenges;
  bool _userPosts;
  bool _institutionPosts;
  String _cityName;
  int _cityID;
  int _categoryID;

  _initFilterValues()
  {
    _counter = 1;
    _cityName = loggedUser.city;
    _isLoading = _userPosts = _institutionPosts = _challenges = false;
    _cityID = loggedUser.cityID; _categoryID = -1;
  }

  _addListenerToScrollController()
  {
    _scrollController.addListener(() async {

      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
        {
          setState(() => _isLoading = true);
          await _infinityScrollrefresh();
          setState(() => _isLoading = false);
        }
    });
  }

  _refreshScreen()
  {
    setState(() => null);
  }

  _infinityScrollrefresh() async
  {
    _counter += 1;
    PostFilterVM data = new PostFilterVM(loggedUser.id, _cityID, _categoryID, _challenges, _userPosts, _institutionPosts, _counter);
    await ChallengeAPIServices.getFilteredPosts(data).then((value){
      _postStreamController.add(value);
      _listOfPosts = value;
    });
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
  
  _loadChallenges() async
  {
    PostFilterVM data = new PostFilterVM(loggedUser.id, _cityID, _categoryID, _challenges, _userPosts, _institutionPosts, _counter);
    await ChallengeAPIServices.getFilteredPosts(data).then((value){
      if(_postStreamController.isClosed)
        return;
      _postStreamController.add(value);
      _listOfPosts = value;
    });
  }

  Future<Null> _handleRefresh() async
  {
    await _loadChallenges();
    return null;
  }

  _filterPosts(bool challenges, bool userPosts, bool institutionPosts, int cityID, int categoryID, String cityName) async
  {
    setState(() {
      _challenges = challenges; _userPosts = userPosts; _institutionPosts = institutionPosts;
      _cityID = cityID; _categoryID = categoryID; _cityName = cityName;
    });

    PostFilterVM filter = new PostFilterVM(loggedUser.id, _cityID, _categoryID, _challenges, _userPosts, _institutionPosts, _counter);
    await ChallengeAPIServices.getFilteredPosts(filter).then((value){
      _postStreamController.add(value);
      _listOfPosts = value;
    });
  }
  
  _refreshOnUserDelete(int postID)
  {
    var challenge = _listOfPosts.firstWhere((element) => element.id == postID);
    _listOfPosts.remove(challenge);
    _postStreamController.add(_listOfPosts);
  }

  _setUpStream()
  {
    _postStreamController = StreamController();
    _stream = _postStreamController.stream;
  }

  @override
  void initState() {
    _initFilterValues();
    _setUpStream();
    _addListenerToScrollController();
    _loadChallenges();
    super.initState();
  }

  @override
  void dispose() {
    _postStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[400],
      endDrawer: FilterSideBar(_filterPosts, _challenges, _userPosts, _institutionPosts, _cityID, _categoryID, _cityName),
      appBar: makeAppBar(),
      body: StreamBuilder(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if(snapshot.hasData)
            return Scrollbar(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){
                            AppPost post = snapshot.data[index];
                            switch (post.typeID) {
                              case PostTypeEnum.challengePost : return ChallengePostComponent(true, _refreshScreen, _refreshOnUserDelete, snapshot.data[index], key: UniqueKey()); break;
                              case PostTypeEnum.userPost: return UserPostComponent(true, _refreshScreen, post, _refreshOnUserDelete, key: UniqueKey()); break;
                              case PostTypeEnum.institutionPost: return UserPostComponent(true, _refreshScreen, post, _refreshOnUserDelete, key: UniqueKey()); break;
                              default: return Container(); break; 
                            }
                         },
                        ),
                      ),
                      if(_isLoading)
                        Container(color: Colors.white, child: BOTFunction.loadingIndicator(),)
                    ],
                  ),
              ),
            );
          else
            return Center(
              child: BOTFunction.loadingIndicator()
            );
        },
      ),
      bottomNavigationBar: BottomNavBar(0),
    );
  }

  AppBar makeAppBar() {
    return AppBar(
      title: Text('Moj grad', style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.08),),
      backgroundColor: Colors.white,
      elevation: 2.0,
      actions: [
        Builder(
          builder: (context)=>IconButton(
            icon: Icon(MaterialCommunityIcons.filter_outline, color: Colors.black,),
            onPressed: () async {
              Scaffold.of(context).openEndDrawer();
            }
          )
        )
      ],
    );
  }

  Widget makeSearchField()
  {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(MaterialCommunityIcons.magnify),
        border: InputBorder.none,
        focusColor: Colors.black,
      ),
    );
  }
}

