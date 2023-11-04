import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:web_app/config/config.dart';

class ImageSliderComponent extends StatefulWidget {

  final List<String> images;
  ImageSliderComponent(this.images);

  @override
  _ImageSliderComponentState createState() => _ImageSliderComponentState();
}

class _ImageSliderComponentState extends State<ImageSliderComponent> {

  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CarouselSlider(
            items: widget.images.map((item) => Image.network(defaultServerURL +item, fit: BoxFit.cover),
            ).toList(),
            options: CarouselOptions(
              autoPlay: false,
              enableInfiniteScroll: false,
              aspectRatio: 1,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _selectedIndex = index;
                });
              }
            ),
          ),
          widget.images.length > 1 ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.map((url) {
              int index = widget.images.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == index
                    ? Colors.green
                    : footerInActiveColor,
                ),
              );
            }).toList(),
          )
          : Container()
        ],
      ),
    );
  }
}