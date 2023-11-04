library my_prj.globals;
import 'package:bot_fe/models/AppModels/AppUser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String logoPath = 'assets/mojGradLogo.png';

//---------------------SERVER ADDRESSES---------------------------

String fikaDefaultServerURL = 'http://192.168.1.6:45455';
String fikaServerURL = 'http://192.168.1.6:45455/api/';
String fikaGetImageURL = 'http://192.168.1.6:45455/api/ImageUpload/';

String borkoDefaultServerURL = 'http://192.168.0.13:45455';
String borkoServerURL = 'http://192.168.0.13:45455/api/';
String borkoGetImageURL = 'http://192.168.0.13:45455/ImageUpload/';

String botDefaultServerURL = 'http://10.0.2.2:60983';
String botServerURL = 'http://10.0.2.2:60983/api/';
String botGetImageURL = 'http://10.0.2.2:60983/api/ImageUpload/';

String defaultServerURL = botDefaultServerURL; 
String serverURL = botServerURL; 
String getImageURL = botGetImageURL;

String imiDefaultServerURL = 'http://147.91.204.116:2063';
String imiServerURL = 'http://147.91.204.116:2063/api/';
String imiGetImageURL = 'http://147.91.204.116:2063/api/ImageUpload/';

String imi2DefaultServerURL = 'http://147.91.204.116:2066';
String imi2ServerURL = 'http://147.91.204.116:2066/api/';
String imi2GetImageURL = 'http://147.91.204.116:2066/api/ImageUpload/';

String botSocket = 'ws://10.0.2.2:60983/student?userID=';
String fikaSocket = 'ws://192.168.1.6:45455/student?userID=';
String imiSocket = 'ws://147.91.204.116:2063/student?userID=';
String imi2Socket = 'ws://147.91.204.116:2066/student?userID=';

//-------------------------//--------------------------------
//-----------------------------------------------------------

String defaultProfilePhoto = "http://10.0.2.2:60983/post/0001/profile.jpg";

String categoryURL = "category";

//-----------COMMENT----------------
String defaultCommentURL = "comment/";
String addCommentWithImagesURL = defaultCommentURL +"withImages";
String deleteCommentLikeURL = defaultCommentURL +"delete?";
String addCommentLikeURL = defaultCommentURL +"add";
String deleteCommentURL = defaultCommentURL +"deleteComment";
String getCommentLikesURL = defaultCommentURL +"likes?";
String commentProposals = defaultCommentURL +"proposals?";
String changeCommentTextURL = defaultCommentURL + "changeCommentData";

//--------------POST--------------------
String defaulPostURL = "challengePost/";
String acceptChallengeURL = defaulPostURL +"AcceptChallenge";
String giveUpTheChallengeURL = defaulPostURL +"giveUpTheChallenge";
String allDbPostsURL = defaulPostURL +"challengepost";
String allAppPostsURL = defaulPostURL +"challenges/";
String addPostURL = defaulPostURL +"ChallengePost";
String acceptedChallengesURL = defaulPostURL +"acceptedChallenges/";
String addPostLikeURL = defaulPostURL +"addLike";
String deletePostLikeURL = defaulPostURL +"deleteLike?";
String deletePostURL = defaulPostURL;
String likesPerPostURL = defaulPostURL +"likes?postID=";
String changePostDataURL = defaulPostURL + "changePostData";
String getAppPostByIdURL = defaulPostURL + "onePost?";
String getAllAppPostsByUserIDURL = defaulPostURL +"appPosts";
String getFilteredPostsURL = defaulPostURL +"filteredPosts";
String postExistanceURL = defaulPostURL +"postExistance";

//----------USER-----------------------
String defaultUserURL = "user/";
String changeProfilePhotoURL = defaultUserURL +"changeProfilePhoto";
String deleteProfilePhotoURL = defaultUserURL +"deleteProfilePhoto/";
String updateUserInfoURL = defaultUserURL +"updateUserInfo";
String loginURL = defaultUserURL +'login';
String registrationURL = defaultUserURL +'registration';
String getAppUserByIdURL = defaultUserURL +"profile/";
String changeUserPasswordURL = defaultUserURL +"updateuserpassword?";
String getTop10UsersURL = defaultUserURL +"top10";
String checkUserExistanceURL = defaultUserURL +"userExistance";

//------------NOTIFICATION------------
String defaultNotificationURL = "notification/";
String readURL = "read/";

//---- ?----
String uploadImagesURL = 'ImageUpload/newPhoto?';

//-----------CITY----------------------
String defaultCityURL = "city";

//--------REPORT-------------
String defaultReportURL = "report/";
String addPostReportURL = defaultReportURL +"postReport";
String addCommentReportURL = defaultReportURL +"commentReport";

//--------USERENTITY------------------
String defaultUserEntityURL = "userEntity/";
String resetPasswordURL = defaultUserEntityURL +"resetUserPassword?";

Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  String loggedUserID;
  bool newNotifications;
  String token;
  AppUser loggedUser;

  List<Category> categories;

  Color bottomBarIconColor = Colors.grey[900];
  Color bottomBarFixedIconColor = Colors.grey[900];

  Color footerColor = Colors.green;
  Color footerInActiveColor = Colors.grey[800];
  Color themeColor = Colors.blueGrey[300];

TextStyle boldText = TextStyle(fontWeight: FontWeight.bold);
