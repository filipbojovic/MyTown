
import 'dart:html';

class Storage
{
  //static set setCookieToken(String value) => window.document.cookie = "token = $value; expiries = "+DateTime.now().add(Duration(days: 2));

  
  static set setUserID(String value) => (value != null) ? window.localStorage["userID"] = value : window.localStorage.remove("userID");
  static String get getUserID => window.localStorage["userID"];

  static set setToken(String value) => (value != null) ? window.localStorage["token"] = value : window.localStorage.remove("token");
  static String get getToken => window.localStorage["token"];

  static set setName(String value) => (value != null) ? window.localStorage["name"] = value : window.localStorage.remove("name");
  static String get getName => window.localStorage["name"];

  static set setUserType(String value) => (value != null) ? window.localStorage["userType"] = value : window.localStorage.remove("userType");
  static String get getUserType => window.localStorage["userType"];

  static set setIndex(String value) => window.sessionStorage["index"] = value;
  static String get getIndex => window.sessionStorage["index"];
}