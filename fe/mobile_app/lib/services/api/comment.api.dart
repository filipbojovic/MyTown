import 'dart:convert';
import 'dart:typed_data';
import 'package:bot_fe/config/config.dart';
import 'package:bot_fe/models/AppModels/AppProposal.dart';
import 'package:bot_fe/models/AppModels/AppReply.dart';
import 'package:bot_fe/models/AppModels/AppUser.dart';
import 'package:bot_fe/models/DbModels/Comment.dart';
import 'package:bot_fe/models/DbModels/CommentLike.dart';
import 'package:bot_fe/ui/sub_pages/LoginScreen.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CommentAPIServices
{
  static Future<List<AppProposal>> getAppProposalsByPostID(int postID) async
  {
    var jwt = await storage.read(key: "jwt");
    Response res = await get(
      serverURL +commentProposals +"postID=" +postID.toString() +"&userID=" +int.parse(loggedUserID).toString(),
      headers:{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt'
      }
    );
    List<AppProposal> props = [];
    if(res.statusCode == 200)
    {
      var jsonProps = jsonDecode(res.body);
      for (var item in jsonProps)
        props.add(AppProposal.fromObject(item));
    }
    return props;
  }

  static Future<List<AppUser>> getUserLikesWithUserInfoByCommentID(int entityID, int commentID)
  async {
    var jwt = await storage.read(key: "jwt");
    Response res = await get(serverURL +getCommentLikesURL +"postID=" +entityID.toString() +"&commentID=" +commentID.toString(), headers: {
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

  static Future<int> addCommentLike(int commentID, int entityID, int userID, int value) async
  {
    var jwt = await storage.read(key: "jwt");
    CommentLike like = new CommentLike(commentID, entityID, userID, value);
    var mapJson = jsonEncode(like.toMap());
    print(mapJson);
    var res = await post(serverURL +addCommentLikeURL, headers:{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: mapJson);

    if(res.statusCode == 201)
      return int.parse(res.body);
    else
      return -1;
  }

  static Future deleteCommentLike(int commentID, int entityID, int userID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await post(serverURL + deleteCommentLikeURL +"commentID=" +commentID.toString() +"&postID=" +entityID.toString() +"&userID=" +userID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
      return int.parse(res.body);
    else
      return -1;
  }

  static Future deleteComment(int commentID, int entityID) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await post(serverURL + deleteCommentURL +"?commentID=" +commentID.toString() +"&postID=" +entityID.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });

    if(res.statusCode == 200)
      return true;
    else
      return false;
  }
  static Future addComment(Comment comment) async
  {
    var jwt = await storage.read(key: "jwt");
    var jsonComment = jsonEncode(comment.toMap());
    var res = await post(serverURL + defaultCommentURL, headers:{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonComment);
    print(res.statusCode);
    if(res.statusCode == 201)
    {
      return AppReply.fromObject(jsonDecode(res.body));
    }
    else
      return null;
  }

  static Future changeCommentText(Map<String, dynamic> data) async
  {
    var jwt = await storage.read(key: "jwt");
    var res = await post(serverURL + changeCommentTextURL, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    
    return res.statusCode;
  }

  static Future addCommentWithPictures(Comment comment, List<Asset> assets) async
  {
    var jwt = await storage.read(key: "jwt");
    Uri uri = Uri.parse(serverURL +addCommentWithImagesURL);
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

    request.fields['Comment[postID]'] = comment.postID.toString();
    request.fields['Comment[userEntityID]'] = comment.userEntityID.toString();
    request.fields['Comment[text]'] = comment.text.toString();
    //request.fields['Comment[parrentID]'] = "2";
    request.fields['Comment[date]'] = comment.date.toString();
    if(comment.latitude != null)
      request.fields['Comment[latitude]'] = comment.latitude.toString();
    if(comment.longitude != null)
    request.fields['Comment[longitude]'] = comment.longitude.toString();
    
    var res = await request.send(); 
    
    var resJson = await Response.fromStream(res);
    if(res.statusCode == 201)
      return AppProposal.fromObject(jsonDecode(resJson.body));
    else
      return res.statusCode.toString();
  }
}