import 'dart:convert';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/DbModels/category.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:http/http.dart';

class CategoryAPIServices
{
  static Future<List<MyCategory>> getCategories() async
  {
    var jwt = await storage.read(key: "jwt");
    Response res = await get(serverURL +categoryURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    List<MyCategory> categories = [];
    var jsonCategories = jsonDecode(res.body);

    for(var item in jsonCategories)
    {
      categories.add(MyCategory.fromObject(item));
    }
    return categories;
  }
}