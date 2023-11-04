
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/EditRankDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Other/NewRankDialog.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/DbModels/Rank.dart';
import 'package:web_app/services/api/rank.api.dart';


bool isVisible = false;

class RankScreen extends StatefulWidget {
  @override
  _RankScreen createState() => _RankScreen();
}

class _RankScreen extends State<RankScreen> {
  String rankName = "";
  int fromValue = 0;
  int toValue = 0;
  String errorMSG = "";

  StreamController _rankStream;
  List<Rank> ranks;
  _getRanks() async
  {
    RankAPIServices.getAllRanks().then((value){
      ranks = value;
      ranks.sort((a,b) => a.startPoints.compareTo(b.startPoints));
      _rankStream.add(value);
    });
  }

  _addRank(Rank rank)
  {
    ranks.add(rank);
    ranks.sort((a,b) => a.startPoints.compareTo(b.startPoints));
    _rankStream.add(ranks);
  }

  _deleteRank(Rank rank)
  {
    ranks.remove(rank);
    _rankStream.add(ranks);
  }

  @override
  void initState() {
    _rankStream = new StreamController();
    ranks = new List<Rank>();
    _getRanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          makeNewRankButton(context),
          Expanded(child: buildExistingRanks()),
        ],
      ),
    );
  }

  Widget buildExistingRanks() {
    return StreamBuilder(
      stream: _rankStream.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) 
      {
        if (!snapshot.hasData) 
          return BOTFunction.loadingIndicator();
        else 
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              color: themeColor,
            ),
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.005,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Rank rank = snapshot.data[index];
                return buildRank(rank, context, index + 1);
              },
            ),
          );
      },
    );
  }


  String name = '';
  String error = "";
  Uint8List data;


  Widget makeNewRankButton(BuildContext context) {
    return RaisedButton(
      color: Colors.green,
      child: Text(
        'Dodaj novi nivo',
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.01
        ),
      ),
      onPressed: () async {
        var res = await showDialog(
          context: context,
          child: NewRankDialog(context)
        );

        if(res != null)
          _addRank(res);
      },
    );
  }

  Widget buildRank(Rank rank, BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          makeIndexLabel(index, context),
          makeRankLogoAndName(context, rank),
          makePointsLabel(rank, context),
          makeButtons(rank, context)
        ],
      ),
    );
  }

  Text makeIndexLabel(int index, BuildContext context) {
    return Text(
      index.toString() +".",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.013,
      ),
    );
  }

  Text makePointsLabel(Rank rank, BuildContext context) {
    return Text(
      rank.startPoints.toString() + " - " + rank.endPoints.toString() + " poena",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.011,
        letterSpacing: 1
      )
    );
  }

  Widget makeRankLogoAndName(BuildContext context, Rank rank) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.035,
          height: MediaQuery.of(context).size.width * 0.035,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(defaultServerURL + rank.path + rank.fileName),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Text(
          rank.name,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.013,
          ),
        )
      ],
    );
  }
  Widget makeButtons(Rank rank, BuildContext _context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          makeDeleteButton(rank, _context),
          SizedBox(width:MediaQuery.of(context).size.width * 0.005),
          makeChangeDataButton(rank),
          // SizedBox(width:MediaQuery.of(context).size.width * 0.005),
          // makeChangeLogoPictureButton(rank)
        ],
      )
    );
  }
  Widget makeDeleteButton(Rank rank, BuildContext _context){
    return Material(
      color: themeColor,
      child: InkWell(
      child: Icon(
        OMIcons.delete,
        size: MediaQuery.of(context).size.width * 0.017),
        onTap: () async{
          var res = await showDialog(
            context: context,
            child: DeleteAlertDialog('Da li ste sigurni da želite da izbrišete dati rank?'),
          );
          if(res)
          {

            showDialog(
              context: _context,
              builder: (context){
                return LoadingDialog("Brisanje ranka...");
              }
            );
            await RankAPIServices.deleteRank(rank.id).then((value){
              Navigator.pop(_context);
              _deleteRank(rank);
            });
          }
        }
      ),
    );
  }

   Widget makeChangeDataButton(Rank rank){
    return Material(
      color: themeColor,
      child: InkWell(
      child: Icon(
        OMIcons.edit,
        size: MediaQuery.of(context).size.width * 0.017),
        onTap: () async {
          Rank data = await showDialog(
              context: context,
              child: EditRankDialog(rank, context),
          );

          if(data != null)
          {
            setState(() {
              rank.setStartPoints = data.startPoints;
              rank.setEndPoints = data.endPoints;
              rank.setName = data.name;
            });
          }
        }
      ),
    );
  }
  //  Widget makeChangeLogoPictureButton(Rank rank){
  //   return Material(
  //     color: themeColor,
  //     child: InkWell(
  //     child: Icon(
  //       OMIcons.photoSizeSelectActual,
  //       size: MediaQuery.of(context).size.width * 0.017),
  //       onTap: () {
  //         pickImage(rank);
  //       }
  //     ),
  //   );
  // }

  // pickImage(Rank rank) 
  // {
  //   final InputElement input = document.createElement('input');
  //   input
  //     ..type = 'file'
  //     ..accept = 'image/*';

  //   input.onChange.listen((e) {
  //     if (input.files.isEmpty) return;
  //     final reader = FileReader();
  //     reader.readAsDataUrl(input.files[0]);
  //     reader.onError.listen((err) => setState(() {
  //           error = err.toString();
  //         }));
  //     reader.onLoad.first.then((res) async {
  //       Map<String, dynamic> data = new Map<String, dynamic>();

  //       final encoded = reader.result as String;
  //       // remove data:image/*;base64 preambule
  //       final stripped =
  //           encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

  //       data["id"] = rank.id;
  //       data["image"] = stripped;

  //       await RankAPIServices.changeRankLogo(data).then((value) async {
  //         // setState(() {
  //         //   ;
  //         //   });
  //         setState(() => name = input.files[0].name);
  //         await _getRanks();
  //           // data = base64.decode(stripped);
  //           // error = null;
            
  //           //have to set the values in class Rank
          
  //       });
  //       setState(() => null);
  //     });
  //   });

  //   input.click();
  // }

}