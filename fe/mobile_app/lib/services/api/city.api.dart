import 'dart:convert';

import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/DbModels/City.dart';
import 'package:http/http.dart';

class CityAPIServices
{
  static Future getAllCities() async
  {
    var res = await get(serverURL +defaultCityURL);

    var citiesObject = jsonDecode(res.body);
    List<City> cities = new List<City>();
    for (var item in citiesObject) {
      cities.add(City.fromObject(item));
    }
    return cities;
  }
}