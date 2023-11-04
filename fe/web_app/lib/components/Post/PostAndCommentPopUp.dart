import 'package:flutter/material.dart';
import 'package:web_app/components/Post/PostComponent.dart';
import 'package:web_app/models/AppModels/AppPost.dart';
import 'CommentScreen.dart';

class PostAndCommentPopUp extends StatelessWidget {
  final AppPost post;
  PostAndCommentPopUp(this.post);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005,
          horizontal: MediaQuery.of(context).size.height * 0.007,
        ),
      // width: MediaQuery.of(context).size.width * 0.2,
      // height: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostComponent(post),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     vertical: 3.0,
                //     horizontal: MediaQuery.of(context).size.width * 0.0008,
                //   ),
                //   height: MediaQuery.of(context).size.height * 0.5,
                //   width: MediaQuery.of(context).size.width * 0.0003,
                //   color: Colors.black,
                // ),
                CommentScreen(post),
              ],
            ),
          ],
        ),
      )
    );
  }
}