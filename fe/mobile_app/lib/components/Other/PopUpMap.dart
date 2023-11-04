import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class PopUpMap extends StatelessWidget {

  final double latitude;
  final double longitude;
  PopUpMap(this.latitude, this.longitude);

  final MapController mapController = new MapController();
   
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        margin: EdgeInsets.all(2.0),
        height: MediaQuery.of(context).size.height * 0.4,
        child:new FlutterMap(
          options: MapOptions(
            center: new LatLng(latitude, longitude),
            zoom: 16.5,
            maxZoom: 17.0,
            minZoom: 8.0,
          ),
          mapController: mapController,
          layers: [new TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: ['a', 'b', 'c']),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  point: LatLng(latitude, longitude),
                  builder: (context) => new Container(
                    child: Icon(
                      MaterialCommunityIcons.map_marker,
                      color: Colors.redAccent[700],
                      size: MediaQuery.of(context).size.width * 0.055,
                    ),
                  ),
                )
              ]
            )
          ]
        ),
      ),
    );
  }
}