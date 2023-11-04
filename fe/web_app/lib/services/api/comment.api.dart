import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:web_app/config/config.dart';
import 'package:web_app/models/AppModels/AppProposal.dart';
import 'package:web_app/models/DbModels/Comment.dart';
import 'package:web_app/services/storage.services.dart';

class CommentAPIServices
{
  static Future<List<AppProposal>> getAppProposalsByPostID(int postID) async
  {
    String loggedUserID = Storage.getUserID;
    var jwt = Storage.getToken;
    Response res = await get(
      serverURL +commentProposals +"postID=" +postID.toString() +"&userID=" +loggedUserID,
      headers:{
        'Content-type': 'application/json',
        'Accept': 'application/json',
       'Authorization': 'Bearer $jwt'
      }
    );
    List<AppProposal> props = new List<AppProposal>();
    if(res.statusCode == 200)
    {
      var jsonProps = jsonDecode(res.body);
      
      for (var item in jsonProps){
        props.add(AppProposal.fromObject(item));
      }
    }
    return props;
  }

  static Future deleteComment(int commentID, int entityID) async
  {
    var jwt = Storage.getToken;
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
    var jwt = Storage.getToken;
    var jsonComment = jsonEncode(comment.toMap());
    var res = await post(serverURL + commentURL, headers:{
      'Content-type': 'application/json',
        'Accept': 'application/json',
       'Authorization': 'Bearer $jwt'
    }, body: jsonComment);

    if(res.statusCode == 201)
      return true;
    else
      return false;
  }

  static Future<bool> addCommentWithPictures(Comment comment, List<Asset> assets) async
  {
    var jwt = Storage.getToken;
    Uri uri = Uri.parse(serverURL +commentURL +addCommentWithImagesURL);
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

      request.fields['Comment[postID]'] = comment.postID.toString();
      request.fields['Comment[userEntityID]'] = comment.userEntityID.toString();
      request.fields['Comment[text]'] = comment.text.toString();
      request.fields['Comment[date]'] = comment.date.toString();
      request.fields['Comment[latitude]'] = comment.latitude.toString();
      request.fields['Comment[longitude]'] = comment.longitude.toString();
    }
    
    var res = await request.send();
    if(res.statusCode == 201)
      return true;
    return false;
  }

  static Future addInstitutionProposal(Comment comment, String image) async
  {
    var jwt = Storage.getToken;
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["comment"] = comment.toMap();
    data["image"] = image;
    var res = await post(serverURL +addInstitutionProposalURL, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );

    if(res.statusCode == 201)
      return AppProposal.fromObject(jsonDecode(res.body));
    else
    {
      return null;
    }
  }

  static Future markReportAsRead(int reportID) async
  {
    var jwt = Storage.getToken;
    var res = await post(serverURL +markPostReportAsReadURL, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }
    );

    if(res.statusCode == 200)
      return true;
    else
      return false;
  }
}