import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_app/components/Tiles/TileAdministratorComponent.dart';
import 'package:web_app/components/other/CreateNewAdministrator.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/DbModels/Administrator.dart';
import 'package:web_app/services/api/administrator.api.dart';
import '../pages/UserScreen.dart';

class AdministratorView extends StatefulWidget {

  final UserFilter filterController;
  AdministratorView(this.filterController);

  @override
  _AdministratorViewState createState() => _AdministratorViewState();
}

class _AdministratorViewState extends State<AdministratorView> {
  
  StreamController _adminStreamController;
  List<Administrator> list = new List<Administrator>();
  Stream _stream;

  _setUpStream()
  {
    _adminStreamController = new StreamController();
    _stream = _adminStreamController.stream;
  }

  _filterUsers(String filterText) async
  {
    print(filterText +" administrator");
    await AdministratorAPIServices.getFilteredAdministrators(filterText).then((value){
      _adminStreamController.add(value);
      list = value;
    });
  }
  _addAdministrator(Administrator admin)
  {
    list.add(admin);
    _adminStreamController.add(list);
  }

  _removeAdministrator(Administrator admin)
  {
    list.remove(admin);
    _adminStreamController.add(list);
  }

  _loadAdministrators() async
  {
    await AdministratorAPIServices.getFilteredAdministrators("").then((value){
      _adminStreamController.add(value);
      list = value;
    });
  }

  @override
  void initState() {
    _setUpStream();
    _loadAdministrators();
    widget.filterController.filterAdmins = _filterUsers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Expanded(
      child:Stack(
          children:[ 
          createBody(context),
          createFloatingButton()
        ]
       )
    );
  }
  Widget createBody(BuildContext _context)
  {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return BOTFunction.loadingIndicator();
        else
        {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.003),
            child: GridView.count(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              crossAxisCount: 5,
              mainAxisSpacing: MediaQuery.of(context).size.height * 0.003,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.002,
              childAspectRatio: MediaQuery.of(context).size.width * 0.30 / MediaQuery.of(context).size.height * 6.2,
              children: List.generate(
                snapshot.data.length,
                (index) {
                  return TileAdministratorComponent(snapshot.data[index], _removeAdministrator, _context, new UniqueKey());
                }
              )
            )
          );
        }
      }
    );
  }



  Widget createFloatingButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: FloatingActionButton(
            onPressed: () async {
              var res = await showDialog(
                context: context, 
                child: CreateNewAdministrator(context)
              );

              if(res != null)
                _addAdministrator(res);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.grey,
        )
      )
    );
  }
}