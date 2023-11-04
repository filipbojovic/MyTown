import 'dart:convert';
import 'package:http/http.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/AppModels/AppReport.dart';
import 'package:web_app/services/storage.services.dart';

class ReportAPIServices {
  static Future getAllAppReports() async {
    var jwt = Storage.getToken;
    //jwt = jwt.substring(1, jwt.length - 1);
    Response res = await get(serverURL + getAllAppReportsURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if (res.statusCode == 200) {
      List<AppReport> list = new List<AppReport>();
      for (var item in jsonDecode(res.body))
        list.add(AppReport.fromObject(item));

      return list;
    } else {
      return null;
    }
  }

  static Future markPostReportAsRead(int postReportID) async {
    var jwt = Storage.getToken;
    Response res = await post(serverURL + markPostReportAsReadURL +"reportID=" +postReportID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );

    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future markCommentReportAsRead(int postReportID) async 
  {
    var jwt = Storage.getToken;
    print(serverURL + markCommentReportAsReadURL +"reportID=" +postReportID.toString());
    Response res = await post(serverURL + markCommentReportAsReadURL +"reportID=" +postReportID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );

    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

}
