import 'dart:async';
import 'package:bot_fe/components/Comments/UserCommentComponent.dart';
import 'package:bot_fe/models/AppModels/AppReply.dart';
import 'package:bot_fe/ui/sub_pages/UserCommentScreen.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'UsersReplyComponent.dart';

class RepliesComponent extends StatefulWidget {

  final UserCommentController commentController;
  final List<AppReply> replies;
  final UserReplyController replyController;
  
  RepliesComponent(this.commentController, this.replyController, this.replies, {Key key}) : super(key: key);

  @override
  _RepliesComponentState createState() => _RepliesComponentState(replies, commentController, replyController);
}

class _RepliesComponentState extends State<RepliesComponent> {
  List<AppReply> _replies = new List<AppReply>();

  _RepliesComponentState(this._replies, UserCommentController _controller, UserReplyController replyController)
  {
    replyController.refreshRepliesOnAdd = _refreshRepliesOnAdd;
  }

  StreamController _repliesStream = new StreamController();
  Stream _stream;
  ExpandableController controller;

  _setUpStream()
  {
    _repliesStream = new StreamController();
    _stream = _repliesStream.stream;
  }
  

  _refreshRepliesOnAdd(AppReply newReply)
  {
    _replies.add(newReply);
    //_replies.insert(0, newReply);
    _repliesStream.add(_replies);
  }

  _refreshRepliesOnDelete(int commentID, int postID)
  {
    var reply = _replies.firstWhere((r) => r.id == commentID && r.postID == postID);
    if(reply != null)
    {
      _replies.remove(reply);
      _repliesStream.add(_replies);
    }
  }

  @override
  void initState() {
    _setUpStream();
    _repliesStream.add(_replies);
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();

  //   _repliesStream.close();
  // }

  @override
  Widget build(BuildContext context) {
    return makeReplies();
  }

  Widget makeReplies()
  {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Container();
        else
        {
          return ExpandableNotifier( //ovo je ceo drugi widget, CEO; sva tri dela posebno mogu da se prosire
            child: ScrollOnExpand(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expandable(
                      collapsed: buildCollapsed(),
                      expanded:  buildExpanded(context, snapshot.data)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            controller = ExpandableController.of(context);
                            return makeExpandButton(controller, context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            )
          );  
        }
      },
    );
  }

  Widget buildCollapsed()
  {
    return Container();
  }

  buildExpanded(BuildContext context, List<AppReply> replyList)
  {
    return ListView.builder(
      itemCount: replyList.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return UsersReplyComponent(widget.commentController, replyList[index], _refreshRepliesOnDelete,_refreshRepliesOnAdd, key: UniqueKey());
      },
    );
  }

  Widget makeExpandButton(ExpandableController controller, BuildContext context) {
    return _replies.length > 0 ? Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.95,
      padding: EdgeInsets.only(top: 5.0),
      height: MediaQuery.of(context).size.height * 0.03,
      child: FlatButton(
        //icon: Icon(controller.expanded? Icons.keyboard_arrow_up : Icons.subdirectory_arrow_left),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 3.0),
              width: MediaQuery.of(context).size.width * 0.05,
              color: Colors.black,
              height: 0.4,
            ),
            Text(
              controller.expanded ? "Sakrij" : "Prikaži odgovore (" +_replies.length.toString() +")",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        onPressed: () {
          controller.toggle();
        },
      ),
    ) : Container();
  }
}