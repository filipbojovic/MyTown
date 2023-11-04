import 'package:web_app/models/Statistic/CategoryStats.dart';
import 'package:web_app/models/Statistic/CityStats.dart';
import 'package:web_app/models/Statistic/TypeStats.dart';
import 'package:web_app/models/Statistic/UserStats.dart';

class AdministratorStats
{
  List<UserStats> _users;
  List<CityStats> _cities;
  List<CategoryStats> _categories;
  List<TypeStats> _types;
  int _numberOfPosts;
  int _numberOfChallenges;
  int _numberOfusers;

  AdministratorStats(this._users, this._cities, this._categories, this._types, this._numberOfPosts, this._numberOfChallenges, this._numberOfusers);

  List<UserStats> get users => this._users;
  List<CityStats> get cities => this._cities;
  List<CategoryStats> get categories => this._categories;
  List<TypeStats> get types => this._types;
  int get numberOfPosts => this._numberOfPosts;
  int get numberOfChallenges => this._numberOfChallenges;
  int get numberOfUsers => this._numberOfusers;

  AdministratorStats.fromObject(dynamic data)
  {
    List<UserStats> users = new List<UserStats>();
    
    for (var item in data["users"])
      users.add(UserStats.fromObject(item));
      
    this._users = users;


    List<CityStats> cities = new List<CityStats>();
    for (var item in data["cities"])
      cities.add(CityStats.fromObject(item));
    this._cities = cities;

    List<CategoryStats> categories = new List<CategoryStats>();
    for (var item in data["categories"])
      categories.add(CategoryStats.fromObject(item));
    this._categories = categories;

    List<TypeStats> types = new List<TypeStats>();
    for (var item in data["types"])
      types.add(TypeStats.fromObject(item));
    this._types = types;

    this._numberOfPosts = data["numberOfPosts"];
    this._numberOfChallenges = data["numberOfChallenges"];
    this._numberOfusers = data["numberOfUsers"];
  }
}