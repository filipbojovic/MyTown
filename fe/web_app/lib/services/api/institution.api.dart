import 'dart:convert';
import 'package:http/http.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/AppModels/AppInstitution.dart';
import 'package:web_app/models/DbModels/institution.dart';
import 'package:web_app/services/storage.services.dart';

class InstitutionAPIServices 
{
  static Future institutionLogin(String email, String password) async
  {
    var res = await post(serverURL +defaultInstitutionURL +institutionLoginURL +"email=" +email +"&password=" +password);

    if(res.statusCode == 200)
      return res.body;
    else
      return null;
  }

  static Future getAllAppInstitutions() async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +getAllAppInstitutionsURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 200)
    {
      List<AppInstitution> list = new List<AppInstitution>();
      for (var item in jsonDecode(res.body))
        list.add(AppInstitution.fromObject(item));

      return list;
    }
    else
      return null;
  }

  static Future addInstitution(Institution institution) async
  {
    var jwt = Storage.getToken;
    var jsonData = jsonEncode(institution.toMap());
    var res = await post(serverURL +defaultInstitutionURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonData);
    if(res.statusCode == 201)
      return AppInstitution.fromObject(jsonDecode(res.body));
    else
      return res.statusCode.toString();
  }
  
  static Future changePassword(int userEntityID, String oldPassword, String newPassword) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +changePasswordURL +"?userEntityID=" +userEntityID.toString() +"&oldPassword=" +oldPassword +"&newPassword=" +newPassword, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt'
        }
      );  

      if(res.statusCode != 404)
        return res.statusCode.toString();
      else
        return null;
  }

  static Future changeData(int userEntityID, String name, String address, String email, String phone) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +changeDataURL +"?userEntityID=" +userEntityID.toString() +"&name=" +name +"&address=" +address +"&email=" +email +"&phone=" +phone, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 204)
      return true;
    else
      return false;
  }

  static Future getAppInstitution(String userEntityID) async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +appInstitutionURL +userEntityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 200)
      return AppInstitution.fromObject(jsonDecode(res.body));
    else
      return null;
  }

  static Future changeProfilePhoto(int userEntityID, String image) async
  {
    var jwt = Storage.getToken;
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["userEntityID"] = userEntityID;
    data["image"] = image;
    var res = await post(serverURL +changeProfilePhotoInstitutionURL, body: jsonEncode(data), headers: {
      'Content-type': 'application/json', 
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 409)
      return res.body.substring(1, res.body.length - 1);
    else
      return false;
  }

  static Future deleteProfilePhoto(int userEntityID) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +deleteProfilePhotoURL +userEntityID.toString(), headers: {
      'Content-type': 'application/json', 
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future getFilteredInstitutions(String filterText, int cityID) async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +getFilteredInstitutionsURL +"filterText=" +filterText +"&cityID=" +cityID.toString(), headers: {
      'Content-type': 'application/json', 
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );

    if(res.statusCode == 200)
    {
      List<AppInstitution> list = new List<AppInstitution>();
      for (var item in jsonDecode(res.body))
        list.add(AppInstitution.fromObject(item));

      return list;
    }
    else
      return null;
  }
}