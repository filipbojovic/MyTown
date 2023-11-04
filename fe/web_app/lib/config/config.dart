import 'package:flutter/material.dart';
import 'package:web_app/models/AppModels/AppInstitution.dart';
import 'package:web_app/models/DbModels/Administrator.dart';

String logoPath = "assets/images/logo.png";
String defaultImageURL = "/profile.png";

String defaultServerURL = imiDefaultServerURL;
String serverURL = imiServerURL;
String getImageURL = imiGetImageURL;
  
String botDefaultServerURL = 'http://127.0.0.1:60983';
String botServerURL = 'http://127.0.0.1:60983/api/';
String botGetImageURL = 'http://127.0.0.1:60983/api/ImageUpload/';

String imiDefaultServerURL = 'http://147.91.204.116:2063';
String imiServerURL = 'http://147.91.204.116:2063/api/';
String imiGetImageURL = 'http://147.91.204.116:2063/api/ImageUpload/';

String botSocket = 'ws://127.0.0.1:60983/student?userID=';
String imiSocket = 'ws://147.91.204.116:2063/student?userID=';

//---------------------USER URLS-----------------------------
String defaultUserURL = "user/";
String allAppUsersURL = "appUsers";
String getUsersUrl = 'user';
String changeProfilePhotoURL = "changeProfilePhoto";
String deleteProfilePhotoURL = defaultUserURL +"deleteProfilePhoto/";
String updateUserInfoURL = "user/updateUserInfo";
String registration = 'registration';
String login = 'login';
String uploadImagesURL = 'ImageUpload/newPhoto?';
String getFilteredUsersURL = defaultUserURL +"filterUsers?";

//------------------ADMINISTRATOR-------------------
String defaultAdministratorURL = "administrator/";
String getDashboardStatsURL = defaultAdministratorURL + "statistic";
String getAllAdministratorsURL = defaultAdministratorURL;
String addAdministratorURL = defaultAdministratorURL;
String deleteAdministratorURL = defaultAdministratorURL +"delete/";
String getFilteredAdministratorsURL = defaultAdministratorURL +"filterAdministrators?";
String changeAdminPasswordURL = defaultAdministratorURL +"changeAdminPassword";

//--------------------REPORT----------------------
String defaultReportURL = "report/";
String getAllAppReportsURL = defaultReportURL + "appReport";
String markPostReportAsReadURL = defaultReportURL + "markPostReportAsRead?";
String markCommentReportAsReadURL = defaultReportURL + "markCommentReportAsRead?";

//----------------INSTITUTION URLS------------------------------
String defaultInstitutionURL = "institution/";
String getAllAppInstitutionsURL = defaultInstitutionURL +"appInstitutions";
String institutionLoginURL = "login?";
String deleteInstitutionURL = "delete?";
String changePasswordURL = defaultInstitutionURL + "changePassword";
String changeDataURL = defaultInstitutionURL + "changeData";
String appInstitutionURL = defaultInstitutionURL +"getAppInstitution/";
String changeProfilePhotoInstitutionURL = defaultInstitutionURL +"changeProfilePhoto";
String getFilteredInstitutionsURL = defaultInstitutionURL +"filterInstitutions?";

//----------------------RANK----------------------------
String defaultRankURL = "rank/";
String addNewRankURL = defaultRankURL;
String changeRankDataURL = defaultRankURL +"rankData";
String changeRankLogoURL = defaultRankURL +"rankLogo";
String deleteRankURL = defaultRankURL;

//--------------------USER_ENTITY-----------------------------
String defaultUserEntityURL = "userEntity/";
String deleteUserEntityURL = defaultUserEntityURL +"delete/";
String resetPasswordURL = defaultUserEntityURL +"resetUserPassword?";

//--------------------------CATEGORY-------------------------------
String categoryURL = "category";

//----------------------POSt-------------------------
String defaultPostURL = "challengePost/";
String deletePostURL = defaultPostURL;
String allDbChallenges = "challengePost/";
String addInstitutionPostURL = defaultPostURL +"institutionPost";
String allChallenges = "ChallengePost/challenges/";
String appPostsByUserEntityID = defaultPostURL +"appPosts/";
String getFilteredPostsURL = defaultPostURL +"filteredPosts";
String getFilteredPostsAdminPageURL = defaultPostURL +"filterPostsAdmin?";

String allCitiesURL = "city";

//---------ENTITY------------
String entityURL = "entity/";

Map<String, String> header = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

String loggedUserID;
AppInstitution loggedUser;
Administrator loggedAdministrator;
String loggedUserFirstName;
String loggedUserLastName;
String loggedUserType;
//String loggedUserProfilePhoto;
String token;


//-----------COMMENT----------------
String commentURL = "comment/";
String addCommentWithImagesURL = "withImages";
String deleteCommentLikeURL = "comment/delete?";
String addCommentLikeURL = "comment/add";
String deleteCommentURL = "comment/deleteComment";
String addInstitutionProposalURL = commentURL +"institutionComment";
String addEntityLikeURL = "entity/add";
String deleteEntityLikeURL = "entity/delete?";
String deleteEntityURL = "entity/deleteEntity";

String getLikes = "likes?";
String commentProposals = "comment/proposals?";

//----------USER-----------------------

String defaultChallengeURL = "challengePost/";
String acceptChallengeURL = "AcceptChallenge";
String giveUpTheChallengeURL = "giveUpTheChallenge";
String addChallengeURL = "ChallengePost";
String acceptedChallengesURL = "acceptedChallenges/";

//------------NOTIFICATION------------
String defaultNotificationURL = "notification/";

String profile = "profile/";

Color bottomBarIconColor = Colors.grey[900];
Color bottomBarFixedIconColor = Colors.grey[900];

Color footerColor = Colors.green;
Color footerInActiveColor = Colors.grey[800];
Color backColor = Colors.grey[300];
TextStyle boldText = TextStyle(fontWeight: FontWeight.bold);

Color themeColor = Colors.blueGrey[100];
Color hoverColor = Colors.green[700];
Color splashColor = Colors.green[900];