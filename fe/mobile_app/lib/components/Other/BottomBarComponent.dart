import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
class BottomBarComponent extends StatefulWidget {

  final int index;
  BottomBarComponent(this.index,);

  @override
  CreateBottomBarComponent createState() => CreateBottomBarComponent(index);
}

class CreateBottomBarComponent extends State<BottomBarComponent> {
  
  int _selectedPage;
  CreateBottomBarComponent(int index) 
  {
    _selectedPage = index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.only(top: 2.5),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.2,
          )
        )
      ),
      child: BottomNavigationBar(
        iconSize: 30.0,
        backgroundColor: Colors.white54,
        elevation: 0.0,
        fixedColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPage,
          onTap: (index) {
            
            setState(() {
                _selectedPage = index;
              });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(OMIcons.home, color: Colors.black), title: Text('Naslovna'), activeIcon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(OMIcons.map, color: Colors.black,), title: Text('Mapa'), activeIcon: Icon(Icons.map)),
            BottomNavigationBarItem(icon: Icon(OMIcons.addAPhoto, color: Colors.black), title: Text('Nova objava')),
            BottomNavigationBarItem(icon: Icon(OMIcons.notifications, color: Colors.black), title: Text('Obavestenja'), activeIcon: Icon(Icons.notifications)),
            BottomNavigationBarItem(icon: Icon(OMIcons.person, color: Colors.black), title: Text('Profil'), activeIcon: Icon(Icons.person))
          ]),
    );
  }
}
