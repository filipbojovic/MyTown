import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/models/DbModels/Rank.dart';
import 'package:web_app/services/api/rank.api.dart';

class NewRankDialog extends StatefulWidget {
  final BuildContext ctx;
  NewRankDialog(this.ctx);
  @override
  _NewRankDialogState createState() => _NewRankDialogState();
}

class _NewRankDialogState extends State<NewRankDialog> {

  String name = '';
  String error = "";
  Uint8List data;
  String errorMessage = "";
  
  final TextEditingController pointsFromCon = new TextEditingController();
  final TextEditingController pointsToCon = new TextEditingController();
  final TextEditingController nameCon = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          makeNameField(),
          makePointFields(),
          if(data != null)
            SizedBox(height: MediaQuery.of(context).size.width * 0.005),
          if(data != null)
            makeOneImageView(),
          SizedBox(height: MediaQuery.of(context).size.width * 0.005),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              makePickImageButton(),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              makeRankSubmitButton(),
            ],
          ),
          if(errorMessage != "")
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            )
        ],
      )
    );
  }

  Widget makeRankSubmitButton()
  {
    return Container(
      child: RaisedButton(
        color: Colors.green,
        child: Text(
          "Dodaj nivo",
          style: TextStyle(
            color: Colors.white, 
            fontSize: MediaQuery.of(context).size.height * 0.02,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: () async {
          var res = _validate();

          if(res)
          {
            showDialog(
              context: widget.ctx,
              child: LoadingDialog("Dodavanje nivoa...")
            );

            Rank rank = new Rank.withOutId(nameCon.text, int.parse(pointsFromCon.text), int.parse(pointsToCon.text), base64.encode(data));
            await RankAPIServices.addNewRank(rank).then((value){
              Navigator.pop(widget.ctx);
              Navigator.pop(context, value);
            });
          }
        },
      ),
    );
  }


  Widget makePointFields(){
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.02, MediaQuery.of(context).size.width * 0.01, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          makePointLabel(),
          makeFromPointField(),
          Text("  -  "),
          makeToPointField(),
        ],
      ),
    );
  }

  Container makeToPointField() 
  {
    return Container(
      width: MediaQuery.of(context).size.width * 0.03,
      height: MediaQuery.of(context).size.height * 0.03,
      child: TextField(
        controller: pointsToCon,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.0005),
          filled: true,
          hoverColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(5)
        ],
      ),
    );
  }

  Container makeFromPointField() {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.08),
      width: MediaQuery.of(context).size.width * 0.03,
      height: MediaQuery.of(context).size.height * 0.03,
      child: TextField(
        controller: pointsFromCon,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.0005),
          filled: true,
          hoverColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green,),
          ),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(5)
        ],
      ),
    );
  }

  Container makePointLabel() {
    return Container(
      child: Text(
        "Opseg poena ",
        style: TextStyle(
          color: Colors.black, 
          fontSize: MediaQuery.of(context).size.width * 0.01,
        ),
      ),
    );
  }

  Widget makePickImageButton()
  {
    return RaisedButton(
      color: Colors.green,
      child: Text(
        "Izaberite sliku",
        style: TextStyle(
          color: Colors.white, 
          fontSize: MediaQuery.of(context).size.height * 0.02,
          letterSpacing: MediaQuery.of(context).size.height * 0.001,
          fontWeight: FontWeight.bold
        ),
      ),
      onPressed: () {
        pickImage();
      },
    );
  }

  Widget makeNameField(){
    return Container(
    width: MediaQuery.of(context).size.width * 0.25,
    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.02, MediaQuery.of(context).size.height * 0.01, MediaQuery.of(context).size.height * 0.02, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Uneti naziv nivoa ",
              style: TextStyle(
                color: Colors.black, //green
                fontSize: MediaQuery.of(context).size.height * 0.02,
                letterSpacing: MediaQuery.of(context).size.height * 0.001,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.04,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
            width: MediaQuery.of(context).size.width * 0.1,
            child: TextField(
              controller: nameCon,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.0005),
                filled: true,
                hoverColor: Colors.white,
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green,),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green,),
                ),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(20)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget makeOneImageView(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
              }
            );  
          }
        );
      }
    );

    input.click();
  }

  bool _validate()
  {
    RegExp number = new RegExp(r'^[0-9]{1,5}$');
    var name = nameCon.text;
    var from = pointsFromCon.text;
    var to = pointsToCon.text;

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
    else if(data == null)
    {
      setState(() => errorMessage = "Izaberite sliku nivoa.");
      return false;
    }
    else
    {
      setState(() => errorMessage = "");
      return true;
    }
  }

}