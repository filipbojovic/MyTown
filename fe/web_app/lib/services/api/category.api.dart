import 'dart:convert';
import 'package:http/http.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/DbModels/Category.dart';
import 'package:web_app/services/storage.services.dart';

class CategoryAPIServices
{
  static Future<List<MyCategory>> getCategories() async
  {
    var jwt = Storage.getToken;
    Response res = await get(serverURL +categoryURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    List<MyCategory> categories = [];
    var jsonCategories = jsonDecode(res.body);
    for(var item in jsonCategories)
      categories.add(MyCategory.fromObject(item));
    return categories;
  }
}