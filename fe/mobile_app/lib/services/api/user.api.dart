import 'dart:convert';
import 'dart:io';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/AppModels/AppUser.dart';
import 'package:bot_fe/models/DbModels/User.dart';
import 'package:bot_fe/models/ViewModels/TopUser.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:http/http.dart';

class UserAPIServices
{
  static Future<dynamic> userLogin(String email, String password) async
  {
    var res = await post(serverURL +loginURL +"?email=" +email +"&password=" +password, headers: header);
    
    if(res.statusCode == 200)
    {
      //var resJSON = json.decode(res.body);
      return res.body;
    }
    else
      return null;
  }

  static Future registerNewUser(User user, String password) async
  {
    Map<String, dynamic> mapData = Map<String, dynamic>();
    var userMap = user.toMap();

    mapData["userData"] = userMap;
    mapData["password"] = password;

    var userJSON = jsonEncode(userMap);
    var res = await post(serverURL +registrationURL +"?password=" +password, headers: header, body: userJSON);
    
    return res.statusCode.toString();
  }
  
  static Future<AppUser> getAppUserByID(int id) async
  {
    var jwt = await storage.read(key: "jwt");
    AppUser user;
    var res = await get(serverURL +getAppUserByIdURL +id.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    if(res.statusCode == 200)
    {
      var json = jsonDecode(res.body);
      user = AppUser.fromObject(json);
      return user;
    }
    else
      return null;
  }

  static Future updateUserInfo(Map<String, dynamic> data) async
  {
    var jwt = await storage.read(key: "jwt");
    var jsonData = jsonEncode(data);
    var res = await put(serverURL +updateUserInfoURL, headers:{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonData);

    if(res.statusCode == 201)
      return true;
    else
      return false;
  }

  static Future changeUserPassword(int userID, String oldPassword, String newPassword) async
  {
    var jwt = await storage.read(key: "jwt"); 
    var res = await put(serverURL +changeUserPasswordURL +"userID=" +userID.toString() +"&oldPassword=" +oldPassword +"&newPassword=" +newPassword, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    return res.statusCode.toString();
  }

  static Future changeProfilePhoto(int userEntityID, File image) async
  {
    var jwt = await storage.read(key: "jwt");
    Uri uri = Uri.parse(serverURL +changeProfilePhotoURL);
    var req = MultipartRequest("POST", uri);
    req.headers["authorization"] = "Bearer $jwt";

    req.fields["userEntityID"] = userEntityID.toString();
    
    var multipartFile = await MultipartFile.fromPath("file", image.path);
    req.files.add(multipartFile);

    var res = await req.send();
    return res.statusCode.toString();
  }

  static Future deleteProfilePhoto(int userEntityID) async
  {
    var jwt = await storage.read(key: "jwt"); 
    var res = await post(serverURL +deleteProfilePhotoURL +userEntityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    
    if(res.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future resetUserPassword(String email, int userTypeID) async
  {
    var res = await post(serverURL +resetPasswordURL +"email=" +email +"&userTypeID=" +userTypeID.toString());

    return res.statusCode.toString();
  }

  static Future getTop10Users() async
  {
    var jwt = await storage.read(key: "jwt"); 
    var res = await get(serverURL +getTop10UsersURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    if(res.statusCode == 200)
    {
      List<TopUser> list = new List<TopUser>();
      for (var item in jsonDecode(res.body))
        list.add(TopUser.fromObject(item));
      return list;
    }
    else
      return null;
  }

  static Future userExistance(int userID) async
  {
    var res = await get(serverURL +checkUserExistanceURL +"?userID=" +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      }
    );
    return res.body;
  }
}