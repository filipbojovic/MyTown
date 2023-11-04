import 'dart:convert';

import 'package:http/http.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/DbModels/Rank.dart';
import 'package:web_app/services/storage.services.dart';

class RankAPIServices 
{
  static Future getAllRanks() async
  {
    var jwt = Storage.getToken;
    //jwt = jwt.substring(1, jwt.length - 1);
    var res = await get(serverURL +defaultRankURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    
    if(res.statusCode == 200)
    {
      List<Rank> ranks = new List<Rank>();
      for (var item in jsonDecode(res.body))
        ranks.add(Rank.fromObject(item));
      return ranks;
    }
    else
      return null;
  }

  static Future changeRankData(Map<String, dynamic> data) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +changeRankDataURL, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 201)
      return Rank.fromObject(jsonDecode(res.body));
    else
      return null;
  }

  static Future changeRankLogo(Map<String, dynamic> data) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +changeRankLogoURL, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    return res.statusCode;
  }

  static Future addNewRank(Rank rank) async
  {
    var jwt = Storage.getToken;
    print(serverURL +addNewRankURL);
    var res = await post(serverURL +addNewRankURL, body: jsonEncode(rank.toMap()), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    
    if(res.statusCode == 201)
      return Rank.fromObject(jsonDecode(res.body));
    else
      return null;
  }

  static Future deleteRank(int rankID) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +deleteRankURL +rankID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    return res.statusCode;
  }
}