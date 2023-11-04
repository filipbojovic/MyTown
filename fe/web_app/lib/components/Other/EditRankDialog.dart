import 'package:flutter/material.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/models/DbModels/Rank.dart';
import 'package:web_app/services/api/rank.api.dart';

class EditRankDialog extends StatefulWidget {
  final Rank rank;
  final BuildContext ctx;
  EditRankDialog(this.rank, this.ctx, {Key key});

  @override
  _EditRankDialogState createState() => _EditRankDialogState();
}

class _EditRankDialogState extends State<EditRankDialog> {


  TextEditingController nameController = TextEditingController();
  TextEditingController startPointsController = TextEditingController();
  TextEditingController endPointsController = TextEditingController();

  
  String error = "";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    nameController.text = widget.rank.name;
    startPointsController.text = widget.rank.startPoints.toString();
    endPointsController.text = widget.rank.endPoints.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0)
      ),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
         width: MediaQuery.of(context).size.width * 0.2,
        child: makeFields(),
      ),
    );
  }

  Widget makeFields(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        makeNameField(),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            makeStartPointsField(),
            Container(child: Text(' - ')),
            makeEndPointsField()
          ],
        ),
        if(errorMessage != "")
          Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
        ),
         Align(
            alignment: Alignment.bottomCenter,  
            child: changeDataButton()
          ),
      ],
    );
  }

  Widget makeNameField(){
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.007),
      width: MediaQuery.of(context).size.width * 0.1,
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
          hintText: "Naziv",
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height * 0.020,
          ),
          border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.0),
          borderSide: new BorderSide(),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
        ),
      )
    );
  }
  Widget makeStartPointsField(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.07,
      child: TextField(
        controller: startPointsController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
          hintText: "Početni opseg",
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height * 0.020,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
        )
      ),
    );
  }

  Widget makeEndPointsField(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.07,
      child: TextField(
        controller: endPointsController,
        decoration: InputDecoration(
          hintText: "Krajnji opseg",
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height * 0.020,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
        ),
      ),
    );
  }
  
  Widget changeDataButton() {
    return Container(
      child: RaisedButton(
        color: Colors.green,
        onPressed: () async {

          if(!_validate())
            return;
          else{
            Map<String, dynamic> data = new Map<String, dynamic>();

            data["id"] = widget.rank.id;
            data["name"] = nameController.text;
            data["startPoint"] = int.parse(startPointsController.text);
            data["endPoint"] = int.parse(endPointsController.text);

            showDialog(
              context: widget.ctx,
              child: LoadingDialog("Izmena podataka u toku...")
            );
            await RankAPIServices.changeRankData(data).then((value) 
            {
              Navigator.pop(widget.ctx);
              if (value == null)
                setState(() => error = "Greška prilikom promene podataka");
              else
                Navigator.pop(context, value);
            });
          }
        },
        child: Text(
          'Izmeni podatke o ranku',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.02,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
          textAlign: TextAlign.center,
        ),
         shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)
          )
        ),
      ),
    );
  }

  
  bool _validate()
  {
    RegExp number = new RegExp(r'^[0-9]{1,5}$');
    var name = nameController.text;
    var from = startPointsController.text;
    var to = endPointsController.text;

    if(name == "")
    {
      setState(() => errorMessage = "Unesite naziv nivoa.");
      return false;
    }
    else if(from == "" || !number.hasMatch(from) || to == "" || !number.hasMatch(to))
    {
      setState(() => errorMessage = "Poeni moraju biti cifre.");
      return false;
    }
    else if(int.parse(from) > int.parse(to))
    {
      setState(() => errorMessage = "Početak opsega poena mora biti manji od kraja opsega.");
      return false;
    }
    else
    {
      setState(() => errorMessage = "");
      return true;
    }
  }
}