import 'dart:convert';
import 'package:http/http.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'package:web_app/models/DbModels/Post.dart';
import 'package:web_app/models/ViewModels/PostFilterVM.dart';
import '../../config/config.dart';
import '../storage.services.dart';

class PostAPIServices
{
  static Future getAppChallengePosts(int userID) async
  {
    var jwt = Storage.getToken;
    Response res = await get(serverURL +allChallenges +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    List<AppPost> posts = [];
    if(res.statusCode == 200)
    {
      var jsonPosts = jsonDecode(res.body);
      for(var item in jsonPosts)
        posts.add(AppPost.fromObject(item));
    }
    return posts;
  }

  static Future deletePost(int postID) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +deletePostURL +postID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future addInstitutionPost(Post instPost, String image) async //adding new post to the base
  {
    var jwt = Storage.getToken;
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["post"] = instPost.toMap();
    data["image"] = image;
    var res = await post(serverURL +addInstitutionPostURL, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 201)
      return AppPost.fromObject(jsonDecode(res.body));
    else
      return null;   
  }

  static Future getAppPostsByUserID(int userID) async //adding new post to the base
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +appPostsByUserEntityID +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 200)
    {
      List<AppPost> list = new List<AppPost>();
      for (var item in jsonDecode(res.body))
        list.add(AppPost.fromObject(item));
      return list;
    }
    else
    {
      return null;
    }   
  }

  static Future getFilteredPosts(PostFilterVM data) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +getFilteredPostsURL, body: jsonEncode(data.toMap()),  headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 200)
    {
      List<AppPost> list = new List<AppPost>();
      for (var item in jsonDecode(res.body))
        list.add(AppPost.fromObject(item));
      return list;
    }
    else
      return null;
  }

  static Future getFilteredPostsAdminPage(String filterText, int cityID, int postType) async
  {
    var jwt = Storage.getToken;
    var res = await get(serverURL +getFilteredPostsAdminPageURL +"filterText=" +filterText +"&cityID=" +cityID.toString() +"&postType=" +postType.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    if(res.statusCode == 200)
    {
      List<AppPost> list = new List<AppPost>();
      for (var item in jsonDecode(res.body))
        list.add(AppPost.fromObject(item));
      return list;
    }
    else
      return null;
  }
}