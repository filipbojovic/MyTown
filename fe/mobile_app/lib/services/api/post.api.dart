import 'dart:convert';
import 'dart:typed_data';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/AppModels/AppAcceptedChallenge.dart';
import 'package:bot_fe/models/AppModels/AppPost.dart';
import 'package:bot_fe/models/AppModels/AppUser.dart';
import 'package:bot_fe/models/DbModels/AcceptedChallenge.dart';
import 'package:bot_fe/models/DbModels/Post.dart';
import 'package:bot_fe/models/DbModels/PostLike.dart';
import 'package:bot_fe/models/ViewModels/PostFilterVM.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ChallengeAPIServices
{
  static addChallengeWithPictures(Post newPost, List<Asset> assets) async
  {
    var jwt = await storage.read(key: "jwt");
    Uri uri = Uri.parse(serverURL +"challengePost");
    var request = MultipartRequest("POST", uri);
    request.headers["authorization"] = "Bearer $jwt";

    for(Asset asset in assets)
    {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      
      var multipartFile = MultipartFile.fromBytes(
        'Images', //name of the field which contains picture(enables the BE to get the image)
        imageData,
        filename: asset.name
      );
      request.files.add(multipartFile);
    }
    
    if(newPost.endDate != null) 
      request.fields['Challenge[title]'] = newPost.title;
    request.fields['Challenge[description]'] = newPost.description;
    request.fields['Challenge[userEntityID]'] = newPost.userEntityID.toString();
    request.fields['Challenge[date]'] = newPost.date.toString();
    if(newPost.categoryID != null)
      request.fields['Challenge[categoryID]'] = newPost.categoryID.toString();
    request.fields['Challenge[cityID]'] = newPost.cityID.toString();
    if(newPost.latitude != null)
      request.fields['Challenge[latitude]'] = newPost.latitude.toString();
    if(newPost.longitude != null)
      request.fields['Challenge[longitude]'] = newPost.longitude.toString();
    if(newPost.endDate != null) 
      request.fields['Challenge[endDate]'] = newPost.endDate.toString();
    request.fields['Challenge[typeID]'] = newPost.typeID.toString();
    
    var res = await request.send();

    return res.statusCode.toString();
  }

  static Future getAppChallengePosts(int userID) async
  {
    var jwt = await storage.read(key: "jwt");
    Response res = await get(serverURL +allAppPostsURL +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    List<AppPost> posts = [];
    if(res.statusCode == 200)
    {
      var jsonPosts = jsonDecode(res.body);
      for(var item in jsonPosts)
        posts.add(AppPost.fromObject(item));
    }
    return posts;
  }

  static Future acceptChallenge(AcceptedChallenge challenge) async
  {
    var jwt = await storage.read(key: "jwt");
    var jsonData = jsonEncode(challenge.toMap());
    var res = await post(serverURL +acceptChallengeURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonData);
    if(res.statusCode == 201)
      return res.body;
    else
      return null;
  }

  static Future giveUpTheChallenge(int postEntityID, int userEntityID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await post(serverURL +giveUpTheChallengeURL +"?postEntityID=" +postEntityID.toString() +"&userEntityID=" +userEntityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    if(res.statusCode == 200)
      return res.body;
    else
      return null;
  }

  static Future getAcceptedChallengesByUser(int userID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await get(serverURL +acceptedChallengesURL +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    
    if(res.statusCode == 200)
    {
      List<AppAcceptedChallenge> list = new List<AppAcceptedChallenge>();
      var mapData = jsonDecode(res.body);
      for (var item in mapData)
        list.add(AppAcceptedChallenge.fromObject(item));
      return list;
    }
    else
    {
      print(res.body);
      return null;
    }
  }

  static Future deletePost(int postID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await post(serverURL +deletePostURL +postID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    return res.statusCode.toString();
  }

  static Future<int> addPostLike(int entityID, int userID) async
  {
    var jwt = await storage.read(key: "jwt");
    PostLike like = new PostLike(entityID, userID);
    var mapJson = jsonEncode(like.toMap());
    var res = await post(serverURL +addPostLikeURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: mapJson);

    if(res.statusCode == 201)
      return int.parse(res.body);
    else
      return res.statusCode;
  }

  static Future deletePostLike(int postID, int userID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await post(serverURL +deletePostLikeURL +"postID=" +postID.toString() +"&userID=" +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
      return int.parse(res.body);
    else
      return res.statusCode;
  }

  static Future<List<AppUser>> getLikesWithUserInfoByPostID(int postID) async
  {
    var jwt = await storage.read(key: "jwt");
    Response res = await get(serverURL +likesPerPostURL +postID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    List<AppUser> users = [];

    if(res.statusCode == 200)
    {
      var jsonUserLikes = jsonDecode(res.body);
      for(var item in jsonUserLikes)
        users.add(AppUser.fromObject(item));
    }
    return users;
  }

  static Future changePostData(Map<String, dynamic> data) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await post(serverURL + changePostDataURL, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    
    return res.statusCode.toString();
  }

  static Future getAppPostByID(int postID, int userID) async
  {
    var jwt = await storage.read(key: "jwt");
    Response res = await get(serverURL +getAppPostByIdURL +"postID=" +postID.toString() +"&userID=" +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    if(res.statusCode == 200)
      return AppPost.fromObject(jsonDecode(res.body));
    else
    {
      print(res.body);
      return null;
    }
  }

  static Future getAppPostsByUserID(int userID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await get(serverURL +getAllAppPostsByUserIDURL +"/" +userID.toString(), headers: {
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
    var jwt = await storage.read(key: "jwt");
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

  static Future postExistance(int postID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await get(serverURL +postExistanceURL +"?postID=" +postID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );
    return res.body;
  }

}