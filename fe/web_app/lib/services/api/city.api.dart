import 'dart:convert';
import 'package:http/http.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/DbModels/City.dart';

class CityAPIServices
{
  static Future<List<City>> getAllCities() async
  {
    var res = await get(serverURL +allCitiesURL);
    var citiesObject = jsonDecode(res.body);
    List<City> cities = new List<City>();
    for (var item in citiesObject) {
      cities.add(City.fromObject(item));
    }
    return cities;
  }
}