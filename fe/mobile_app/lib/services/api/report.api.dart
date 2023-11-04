import 'dart:convert';

import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/DbModels/CommentReport.dart';
import 'package:bot_fe/models/DbModels/PostReport.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:http/http.dart';

class ReportAPIServices
{
  static Future addPostReport(PostReport report) async 
  {
    var jwt = await storage.read(key: "jwt");
    var dataToSend = jsonEncode(report.toMap());
    var res = await post(serverURL +addPostReportURL, body: dataToSend, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 201)
      return true;
    {
      return false;
    }
  }

  static Future addCommentReport(CommentReport report) async 
  {
    var jwt = await storage.read(key: "jwt");
    var dataToSend = jsonEncode(report.toMap());
    var res = await post(serverURL +addCommentReportURL, body: dataToSend, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 201)
      return true;
    else
    {
      print(res.body);
      return false;
    }
  }
}