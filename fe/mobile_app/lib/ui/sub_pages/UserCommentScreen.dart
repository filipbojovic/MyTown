import 'dart:async';
import 'dart:convert';
import 'package:bot_fe/components/Comments/UserCommentComponent.dart';
import 'package:bot_fe/components/Comments/UsersProposalComponent.dart';
import 'package:bot_fe/components/Other/ConfirmDialog.dart';
import 'package:bot_fe/components/Other/LoadingDialog.dart';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/functions/function.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/models/AppModels/AppProposal.dart';
import 'package:bot_fe/models/AppModels/AppReply.dart';
import 'package:bot_fe/models/DbModels/Comment.dart';
import 'package:bot_fe/models/DbModels/CommentNotification.dart';
import 'package:bot_fe/services/api/comment.api.dart';
import 'package:bot_fe/services/api/notification.services.dart';
import 'package:bot_fe/services/picture.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UserCommentController
{
  void Function(bool value, String fullName, int receiverID, int commentID, int userTypeID) changeReplyStatus;
  void Function(AppProposal comment) refreshCommentListOnAdd;
  void Function(int commentID, int postID) refreshCommentOnDelete;
  void Function(AppReply reply) refreshRepliesOnAdd;
  void Function(int value) solvedByTheUserChange;
}

class UserCommentScreen extends StatefulWidget {
  final AppPost post;
  final bool showAppBar; //true for commentPage, false for PAC page
  final Function rebuild; //rebuild replies component on reply add (for pac page)
  UserCommentScreen(this.post, this.showAppBar, this.rebuild);
  
  @override
  UserCommentScreenState createState() => UserCommentScreenState();
}

class UserCommentScreenState extends State<UserCommentScreen> with AutomaticKeepAliveClientMixin {
  
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
  String _error = "";
  
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
    widget.post.incrementCommentCount(-1);
    var prop = _commentList.firstWhere((element) => element.id == commentID && element.postID == entityID);
    _commentList.remove(prop);
    _commentStreamController.add(_commentList);
  }

  _refreshCommentListOnAdd(AppProposal newComment)
  {
    widget.post.incrementCommentCount(1);
    _commentList.add(newComment);
    //_commentList.insert(0, newComment);
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
    
  //   @override
  // void dispose() {
  //   super.dispose();
  //   _commentStreamController.close();
  // }

  @override
  Widget build(BuildContext context) 
  {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot)
      {
        if(!snapshot.hasData)
          return BOTFunction.loadingIndicator();
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
            
            return widget.showAppBar ? Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              appBar: makeAppBar(),
              body: makeBody(snapshot),
            ) : makePacBody(snapshot.data);
          }
      }, 
    );
  }

  Widget makeBody(AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        snapshot.data.length > 0 ? Expanded(
          child: Scrollbar(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                cacheExtent: 10,
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  AppProposal comment = snapshot.data[index];
                  return Column(
                    children: [
                      widget.post.typeID == PostTypeEnum.challengePost ? UsersProposalComponent(_refreshCommentController, comment, _scaffoldKey, key: UniqueKey()) : UserCommentComponent(comment, _refreshCommentController, key: UniqueKey()),
                    ],
                  );
                },
              ),
            ),
          ),
        ) : Expanded(child: BOTFunction.noContent(widget.post.typeID == PostTypeEnum.challengePost ? "Nema rešenja." : "Nema komentara.")),
        CommentBottomBar(_commentController, widget.post, _scrollController, _refreshCommentController, _commentList, _scaffoldKey, null)
      ],
    );
  }

  Widget makePacBody(List<AppProposal> comments)
  {
    return ListView(
      addAutomaticKeepAlives: true,
      cacheExtent: 10,
      controller: _scrollController,
      physics: widget.showAppBar ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        CommentBottomBar(_commentController, widget.post, _scrollController, _refreshCommentController, _commentList, _scaffoldKey, widget.rebuild),
        if(comments.length == 0)
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: BOTFunction.noContent(widget.post.typeID == PostTypeEnum.challengePost ? "Nema rešenja." : "Nema komentara.")
            )
          ),
        for (var item in comments)
          widget.post.typeID == PostTypeEnum.challengePost ? UsersProposalComponent(_refreshCommentController, item, _scaffoldKey, key: UniqueKey()) : UserCommentComponent(item, _refreshCommentController, key: UniqueKey()),
      ],
    );
  }
  AppBar makeAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CommentBottomBar extends StatefulWidget {

  final TextEditingController commentController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserCommentController replyController;
  final List<AppProposal> commentList;
  final ScrollController scrollController;
  final AppPost post;
  final Function rebuild;
  CommentBottomBar(this.commentController, this.post, this.scrollController, this.replyController, this.commentList, this.scaffoldKey, this.rebuild);

  @override
  _CommentBottomBarState createState() => _CommentBottomBarState(commentController, replyController, post);
}

class _CommentBottomBarState extends State<CommentBottomBar> {

  AppPost post;
  TextEditingController _commentController;
  _CommentBottomBarState(this._commentController, UserCommentController _replyController, this.post)
  {
    _replyController.changeReplyStatus = _changeReplyToStatus;
  }

  bool _replyToUser;
  String _replyToFullName;
  int _commentToReplyID;
  int _receiverID;
  int _userTypeID;
  String _error;

  bool _textFieldFocus = false;

  List<Asset> images;

  StreamController _replyToStream; //to enable comment if user did not put the proposal 
  Stream _replyStream;

  _initReplyToStream()
  {
    _replyToStream = StreamController();
    _replyStream = _replyToStream.stream; //(ako se trenutno odgovara nekom AND u pitanju je izazov) ILI (u pitanju je obicna objava) => NEMOJ DA BLOKIRAS
    bool value = post.typeID != PostTypeEnum.challengePost ? true : ((_replyToUser || (post.acceptedByTheUser && post.solvedByTheUser == 0)) ? true : false);
    _replyToStream.add(value);
  }
  
  _changeReplyToStatus(bool value, String fullName, int receiverID, int commentID, int userTypeID)
  {
    setState(() {
      if(post.typeID == PostTypeEnum.challengePost)
        _replyToStream.add(value);
      _replyToUser = value;
      _replyToFullName = fullName;
      _commentToReplyID = commentID;
      _receiverID = receiverID;
      _userTypeID = userTypeID;
      _commentController.text = "@" +fullName +" ";
    });
  }

  @override
  void initState() {
    images = new List<Asset>();
    _replyToUser = false;
    _error = "";
    _initReplyToStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _replyStream,
      builder: (context, snapshot) {
        if(!snapshot.hasData || (snapshot.hasData && !snapshot.data))
          return Container();
        else
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black, width: 0.5)
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(_replyToUser)
                makeReplyToBox(),
              if(images.length > 0) Container(
                height: MediaQuery.of(context).size.height * 0.12,
                child: ListView.builder(
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return makeOneImageView(images[index], index);
                  },
                ),
              ),
              if(_error != "") 
                makeErrorLabel(),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Row(
                  children: [
                    if(!_replyToUser) GestureDetector(
                      onTap: () async {
                        await Picture.loadAssets(images, 2).then((value){
                          if(!mounted)
                            return;
                          setState(() {
                            images = value;
                          });
                        });
                      },
                      child: Icon(MaterialCommunityIcons.camera_outline),
                    ),
                    makeCommentTextField(),
                    makeSendButton(context),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget makeSendButton(BuildContext _context)
  {
    return GestureDetector(
      onTap: () async {
        if(_commentController.text == "")
        {
          showDialog(
            context: context,
            child: ConfirmDialog("Unesite tekst komentara.")
          );
          return;
        }

        if(_replyToUser)
        {
          showDialog(
            barrierDismissible: false,
            context: _context,
            builder: (context){
              return LoadingDialog("Postavljanje odgovora...");
            }
          );

          await CommentAPIServices.addComment(new Comment.withOutID(post.id, loggedUser.id, _commentController.text, _commentToReplyID, DateTime.now(), null, null)).then((value){
            Navigator.pop(context);
            if(value != null)
            {
              widget.replyController.refreshRepliesOnAdd(value);

              if(loggedUser.id != _receiverID && _userTypeID != UserTypeEnum.institution)
              {
                CommentNotification cn = new CommentNotification(int.parse(loggedUserID), _receiverID, widget.post.id, _commentToReplyID, NotificationTypeEnum.commentReply, false, DateTime.now());
                NotificationServices.channel.sink.add(jsonEncode(cn.toMap()));
              }
            }
          });
          setState(() => _replyToUser = false);
          if(widget.rebuild != null)
            widget.rebuild(); //rebuild page with post and comments on the same page.
        }
        else
        {
          if(post.typeID == PostTypeEnum.challengePost && images.length == 0)
          {
            showDialog(
              context: context,
              child: ConfirmDialog("Mora se postaviti i slika rešenja.")
            );
            return;
          }
          showDialog(
            barrierDismissible: false,
            context: context,
            child: LoadingDialog(widget.post.typeID == PostTypeEnum.challengePost ? "Postavljanje rešenja..." : "Postavljanje komentara..."),
          );

          await CommentAPIServices.addCommentWithPictures(new Comment.withOutID(post.id, loggedUser.id, _commentController.text, null, DateTime.now(), null, null), images).then((value) async {
            Navigator.pop(context);
            if(value == "422")
            {
              setState(() => _error = "Slika mora biti u .jpg, .png ili .jpeg formatu.");
              return;
            }
            else if(value == "404")
            {
              await showDialog(
                context: context,
                child: ConfirmDialog("Sadržaj na koji reagujete više ne postoji.")
              );
              return;
            }
            else if(value is AppProposal)
            {
              widget.replyController.refreshCommentListOnAdd(value);

              if(post.typeID == PostTypeEnum.challengePost)
              {
                setState(() => loggedUser.solveChallenge());
                widget.replyController.solvedByTheUserChange(1);
              }
              if(loggedUser.id != widget.post.userEntityID)
              {
                CommentNotification cn = new CommentNotification(int.parse(loggedUserID), widget.post.userEntityID, widget.post.id, value.id, widget.post.typeID == PostTypeEnum.challengePost ? NotificationTypeEnum.newProposal : NotificationTypeEnum.newComment, false, DateTime.now());
                NotificationServices.channel.
                sink.add(jsonEncode(cn.toMap()));
              }
              setState(() => _error = "");
            }
            else
              setState(() => _error = "Došlo je do greške. Proverite internet konekciju.");
          });
        }

        if(post.typeID == PostTypeEnum.challengePost)
          _replyToStream.add(false);

        _commentController.text = "";
        images.clear();
        FocusScope.of(context).requestFocus(new FocusNode());
        // _scrollUp();
      },
      child: Icon(MaterialCommunityIcons.send, color: Colors.green),
    );
  }

  Widget makeErrorLabel(){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03
      ),
      child: Text(
        _error,
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: MediaQuery.of(context).size.width * 0.037
        ),
      ),
    );
  }

  void _scrollUp()
  {
    widget.scrollController.animateTo(
      0, duration: Duration(microseconds: 1000),
      curve: Curves.easeInOut
    );
  }

  Container makeReplyToBox() {
    return Container(
      color: Colors.grey[600],
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
            child: Text('odgovor za ' +_replyToFullName, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.04)),
          ),
          Padding(
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
            child: Material(
              color: Colors.grey[600],
              child: InkWell(
                enableFeedback: false,
                onTap: (){
                  setState(() {
                    _replyToUser = false;
                    if(post.typeID == PostTypeEnum.challengePost)
                      _replyToStream.add(false);

                    _commentController.text = "";
                    // _replyToFullName = null;
                    // _commentToReplyID = null;
                    // _receiverID = null;
                  });
                },
                child: Text(
                  'x', 
                  style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05)
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded makeCommentTextField() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.015),
        child: TextField(
          autofocus: _textFieldFocus,
          maxLines: null,
          controller: _commentController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
            hintText: post.typeID == PostTypeEnum.challengePost ? 'Postavite rešenje...' : 'Napiši komentar...',
            fillColor: Colors.grey[300],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                width: 0.0,
                style: BorderStyle.none
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget makeOneImageView(Asset image, int index){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.01,
          ),
          height: MediaQuery.of(context).size.height * 0.11,
          width: MediaQuery.of(context).size.width * 0.15,
          child: AssetThumb(
            asset: image,
            height: 1920,
            width: 1080,
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              images.removeAt(index);
            });
          },
          child: Icon(MaterialCommunityIcons.close_circle_outline)
        )
      ],
    );
  }

}