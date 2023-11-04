import 'dart:convert';

import 'package:http/http.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/DbModels/Administrator.dart';
import 'package:web_app/models/Statistic/AdministratorStats.dart';
import 'package:web_app/services/storage.services.dart';

class AdministratorAPIServices
{
  static Future getDashboardStatistic() async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +getDashboardStatsURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 200){
      return AdministratorStats.fromObject(jsonDecode(res.body));
    }
    else
    {
      return null;
    }
  }

  static Future getAllAdministrators() async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +getAllAdministratorsURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
    {
      List<Administrator> list = new List<Administrator>();
      for (var item in jsonDecode(res.body))
        list.add(Administrator.fromObject(item));
      return list;
    }
    else
      return null;
  }

  static Future addAdministrator(Administrator data) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +getAllAdministratorsURL, body: jsonEncode(data.toMap()), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 201)
      return Administrator.fromObject(jsonDecode(res.body));
    else
      return res.statusCode.toString();
  }

  static Future deleteAdministrator(int userEntityID) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +defaultAdministratorURL +userEntityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future getAdministratorByID(String adminID) async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +defaultAdministratorURL +adminID, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
      return Administrator.fromObject(jsonDecode(res.body));
    else
      return null;
  }

  static Future getFilteredAdministrators(String filterText) async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +getFilteredAdministratorsURL +"filterText=" +filterText, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
    {
      List<Administrator> list = new List<Administrator>();
      for (var item in jsonDecode(res.body))
        list.add(Administrator.fromObject(item));
      return list;
    }
    else
      return null;
  }

  static Future resetUserPassword(String email, int userTypeID) async
  {
    var res = await post(serverURL +resetPasswordURL +"email=" +email +"&userTypeID=" +userTypeID.toString());

    return res.statusCode.toString();
  }

  static Future changeAdminPassword(int adminID, String oldPassword, String newPassword) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +changeAdminPasswordURL +"?adminID=" +adminID.toString() +"&oldPassword=" +oldPassword +"&newPassword=" +newPassword, headers: {
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

}