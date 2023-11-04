import 'package:bot_fe/config/config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSliderComponent extends StatefulWidget {

  final List<String> images;
  ImageSliderComponent(this.images);

  @override
  _ImageSliderComponentState createState() => _ImageSliderComponentState();
}

class _ImageSliderComponentState extends State<ImageSliderComponent> {

  //PageController pageController;
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    //pageController = PageController(initialPage: 0, viewportFraction:1.0);
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            child: CarouselSlider(
              items: widget.images.map((item) => Image.network(defaultServerURL +item, fit: BoxFit.cover),
              ).toList(),
              options: CarouselOptions(
                autoPlay: false,
                enableInfiniteScroll: false,
                aspectRatio: 1.4,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              ),
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