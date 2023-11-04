import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Picture
{
  static Widget buildGridView(List<Asset> images) //prikaz vise slika
  {
    return GridView.count(
      padding: EdgeInsets.all(8.0),
      crossAxisCount: 6,
      mainAxisSpacing: 4.0,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      crossAxisSpacing: 4.0,
      children: List.generate(images.length, (index){
        Asset asset = images[index];
        return AssetThumb(
          asset: asset, 
          height: 1920, 
          width: 1080,
        );
      })
    );
  }

  static Future<List<Asset>> loadAssets(List<Asset> images, int maxImg) async //returns imgs choosen from gallary
  {
    List<Asset> picList = List<Asset>();
    try
    {
      picList = await MultiImagePicker.pickImages(
      maxImages: maxImg,
      enableCamera: true,
      selectedAssets: images, //containt list of selected pictures, so if user come back to choose again, pics will be selected already
      materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
            actionBarTitle: "Example App",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
        ),
      );
    }
    on Exception catch (e)
    {
      print(e.toString());
    }
    return picList;
  }
  
  static Future getImageFromCam() async
  {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  static Future getImageFromGallery() async
  {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

}