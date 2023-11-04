import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_app/components/Other/DeleteAlertDialog.dart';
import 'package:web_app/components/Other/LoadingDialog.dart';
import 'package:web_app/components/Post/PostAndCommentPopUp.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/services/api/post.api.dart';
import 'package:web_app/services/storage.services.dart';

class TilePostComponent extends StatefulWidget {
  final AppPost post;
  final Function deletePost;
  final BuildContext ctx;

  TilePostComponent(this.ctx, this.post, this.deletePost, {Key key}) : super(key: key);

  @override
  _TilePostComponentState createState() => _TilePostComponentState();
}

class _TilePostComponentState extends State<TilePostComponent> {
  bool hasPicture;
  BOTFunction bot = new BOTFunction();
  @override
  Widget build(BuildContext context) {
    hasPicture = widget.post.imageURLS.isNotEmpty;
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.001),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: themeColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(hasPicture)
            makePostPhoto(context),
          makePostInfo(context, hasPicture),
          makeButtons(context),
        ],
      ),
    );
  }

  Container makePostPhoto(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.005,horizontal: MediaQuery.of(context).size.width * 0.003),
      child: CircleAvatar(
        backgroundImage: NetworkImage(defaultServerURL +widget.post.imageURLS[0],),
        radius: MediaQuery.of(context).size.width * 0.04,
      ),
      width: MediaQuery.of(context).size.width * 0.04,
      height: MediaQuery.of(context).size.height,
    );
  }

  Widget makeButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Material(
          color: themeColor,
          child: InkWell(
            child: Icon(MaterialCommunityIcons.information_outline,
                color: Colors.black,
                size: MediaQuery.of(context).size.width * 0.015),
            onTap: () {
              showDialog(
                context: context,
                child: PostAndCommentPopUp(widget.post),
              );
            }
          ),
        ),
        int.parse(Storage.getUserType) == UserTypeEnum.administrator?
        Material(
          color: themeColor,
          child: InkWell(
            child: Icon(MaterialCommunityIcons.trash_can_outline,
                size: MediaQuery.of(context).size.width * 0.015),
            onTap: () async {
              var res = await showDialog(
                context: widget.ctx,
                child: DeleteAlertDialog('Da li ste sigurni da želite da izbrišete datu objavu?'),
              );

              if(res)
              {
                _showDeleteDialog();

                PostAPIServices.deletePost(widget.post.id).then((value){
                  Navigator.pop(widget.ctx);
                  widget.deletePost(widget.post);
                });
              }
            },
          ),
        ): Container()
      ],
    );
  }

  _showDeleteDialog()
  {
    showDialog(
      context: widget.ctx,
      child: LoadingDialog("Brisanje objave u toku...")
    );
  }

  Container makePostInfo(BuildContext context, bool hasPictures) 
  {
    String text = widget.post.typeID == PostTypeEnum.challengePost ? 
      widget.post.title : 
      widget.post.description;
    if (text.length > 60) 
    {
      widget.post.imageURLS.length > 0 ?
       text = text.substring(0, 57) + "..." : 
       text = text.substring(0, 60) + "..." ;
      //if (text.contains("\n")) text = text.substring(0, text.indexOf("\n"));
    }
    return Container(
      width: hasPictures ? MediaQuery.of(context).size.width * 0.14 : MediaQuery.of(context).size.width * 0.18,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.008,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Text('Autor: ' + widget.post.fullName,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.009,
                  color: Colors.black)),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text:
                        widget.post.typeID != 3 ? BOTFunction.getTimeDifference(widget.post.date) + ', ' : BOTFunction.formatDateDayMonthYear(widget.post.date),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        color: Colors.black),
                  ),
                  if (widget.post.typeID == PostTypeEnum.challengePost)
                    TextSpan(
                        text: widget.post.cityName,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.009,
                            color: Colors.blue))
                ]),
              )
            ],
          )
        ],
      ),
    );
  }
}
