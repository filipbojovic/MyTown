import 'package:bot_fe/config/config.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(logoPath),
                  fit: BoxFit.contain
                )
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'obezbedio\n',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05
                    )
                  ),
                  TextSpan(
                    text: 'BOT',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold
                    )
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}