import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_app/components/Comments/UserCommentComponent.dart';
import 'package:web_app/functions/BOTFunction.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/models/AppModels/AppProposal.dart';
import 'package:web_app/models/AppModels/AppReply.dart';
import 'package:web_app/services/api/comment.api.dart';
import 'package:web_app/services/storage.services.dart';

class UserCommentController
{
  void Function(bool value, String fullName, int receiverID, int commentID) changeReplyStatus;
  void Function(AppProposal comment) refreshCommentListOnAdd;
  void Function(int commentID, int postID) refreshCommentOnDelete;
  void Function(AppReply reply) refreshRepliesOnAdd;
  void Function(int value) solvedByTheUserChange;
}

class CommentScreen extends StatefulWidget {
  final AppPost post;
  CommentScreen(this.post);
  
  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> with AutomaticKeepAliveClientMixin {
  
  final ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController _commentStreamController;
  Stream _stream;

  List<AppProposal> _commentList = [];

  final UserCommentController _refreshCommentController = new UserCommentController();
  TextEditingController _commentController;
  int commentIDToAnswer;
  StateSetter setstate;
  List<AppReply> replies = [];
  bool replyToUser = false;

  loadComments() async
  {
    CommentAPIServices.getAppProposalsByPostID(widget.post.id).then((res) async {
      _commentStreamController.add(res);
      _commentList = res;
      return res;
    });
  }

  _changeSolvedByTheUserStatus(int value)
  {
    setState(() {
      widget.post.setSolvedByTheUser = value;
    });
  }

  Future<Null> _handleRefresh() async
  {
    CommentAPIServices.getAppProposalsByPostID(widget.post.id).then((res) async {
      _commentStreamController.add(res);
      _commentList = res;
      return null;
    });
  }

  _refreshCommentListOnDelete(int commentID, int entityID)
  {
    var prop = _commentList.firstWhere((element) => element.id == commentID && element.postID == entityID);
    
    _commentList.remove(prop);
    _commentStreamController.add(_commentList);
  }

  _refreshCommentListOnAdd(AppProposal newComment)
  {
    _commentList.insert(0, newComment);
    _commentStreamController.add(_commentList);
  }

  _setUpStream()
  {
    _commentStreamController = new StreamController();
    _stream = _commentStreamController.stream;
  }

  bool isVisible = false;
  TextEditingController commentController;

  @override
  void initState() {
    
    _setUpStream();
    loadComments();
    _commentController = new TextEditingController();
    _refreshCommentController.refreshCommentListOnAdd = _refreshCommentListOnAdd;
    _refreshCommentController.refreshCommentOnDelete = _refreshCommentListOnDelete;
    _refreshCommentController.solvedByTheUserChange = _changeSolvedByTheUserStatus;

    super.initState();
  }
    
    @override
  void dispose() {
    super.dispose();
    _commentStreamController.close();
  }

  @override
  Widget build(BuildContext context) 
  {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot){
        if (snapshot.hasError) {
            return Text(snapshot.error);
        }
        if(!snapshot.hasData)
          return Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.52,
          );
        else
          {
            if(snapshot.data.length > 1 && widget.post.typeID == PostTypeEnum.challengePost)
            {
              List<AppProposal> list = snapshot.data;
              var index = list.indexWhere((e) => e.userTypeID == UserTypeEnum.institution);

              if(index != -1)
              {
                var institutionSolution = list[index];
                list.removeWhere((e) => e.id == institutionSolution.id && e.postID == institutionSolution.postID);
                list.insert(0, institutionSolution);
              }
            }
            return snapshot.data.length > 0 ? Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: Storage.getUserType == UserTypeEnum.administrator.toString() ? MediaQuery.of(context).size.height * 0.52 : MediaQuery.of(context).size.height * 0.62,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Scrollbar(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                          addAutomaticKeepAlives: true,
                          cacheExtent: 10,
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){
                            AppProposal comment = snapshot.data[index];
                            return UserCommentComponent(comment, _refreshCommentController, key: UniqueKey());
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container();
          }
      }, 
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
