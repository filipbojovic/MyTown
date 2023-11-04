import 'dart:convert';
import 'package:http/http.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/AppModels/AppUser.dart';
import 'package:web_app/models/DbModels/User.dart';
import 'package:web_app/services/storage.services.dart';

class UserAPIServices
{
  static Future<dynamic> administratorLogin(String username, String password) async
  {
    var res = await post(serverURL +defaultAdministratorURL +login +"?email=" +username +"&password=" +password, headers: header);
    
    if(res.statusCode == 200)
      return res.body;
    else
      return null;
  }

  static Future<dynamic> registerNewUser(User user, String password) async
  {
    Map<String, dynamic> mapData = Map<String, dynamic>();
    var userMap = user.toMap();

    mapData["userData"] = userMap;
    mapData["password"] = password;

    var userJSON = jsonEncode(userMap);

    var res = await post(serverURL +defaultUserURL +registration +"?password=" +password, headers: header, body: userJSON);
    if(res.statusCode == 201) //if it is succesfully created
    {
      var resJSON = json.decode(res.body);
      return resJSON;
    }
    else
      return null;
  }

  static Future deleteUserEntity(int userEntityID) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +deleteUserEntityURL +userEntityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    return res.statusCode;
  }

  static Future getFilteredUsers(String filterText, int cityID) async
  {
    var jwt = Storage.getToken;
    Response res = await get(serverURL +getFilteredUsersURL +"filterText=" +filterText +"&cityID=" +cityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

      List<AppUser> users = new List<AppUser>();

      if(res.statusCode == 200)
      {
        for(var item in json.decode(res.body))
          users.add(AppUser.fromObject(item));
      }
      return users; 
  }
}