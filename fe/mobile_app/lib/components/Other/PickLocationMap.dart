import 'package:bot_fe/services/location.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class PickLocationMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Function changePosition;
  PickLocationMap(this.latitude, this.longitude, this.changePosition);

  @override
  _PickLocationMapState createState() => _PickLocationMapState();
}

class _PickLocationMapState extends State<PickLocationMap> {

  final MapController mapController = new MapController();
  double _latitude;
  double _longitude;

  @override
  void initState() {
    _latitude = widget.latitude;
    _longitude = widget.longitude;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
      child: Stack(
        children: [
          makeMap(),
          makeButton(context),
          makeGoToDefaultLocationButton()
        ],
      ),
    );
  }

  Widget makeButton(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          color: Colors.green,
          child: Text(
            "U redu",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04
            ),
          ),
          onPressed: (){
            var data = new Map<String, dynamic>();
            data["latitude"] = _latitude;
            data["longitude"] = _longitude;
            Navigator.pop(context, data);
          },
        ),
      ),
    );
  }

  Widget makeGoToDefaultLocationButton()
  {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.012,
      right: MediaQuery.of(context).size.height * 0.01,
      child: InkWell(
        enableFeedback: false,
        onTap: () async 
        {  
          Position data = await Location.getLatLongPosition();

          mapController.move(LatLng(data.latitude, data.longitude), 16.0);
          setState(() {
            _latitude = data.latitude;
            _longitude = data.longitude;
          });
        },
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35.0)
          ),
          child: Icon(MaterialCommunityIcons.crosshairs_gps)
        ),
      )
    );
  }

  Widget makeMap() {
    return Container(
      margin: EdgeInsets.all(1.0),
      height: MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        options: MapOptions(
          center: new LatLng(_latitude, _longitude),
          onTap: _changeMarkerPosition,
          zoom: 16.0,
          maxZoom: 17.0,
          minZoom: 8.0,
        ),
        mapController: mapController,
        layers: [new TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                point: LatLng(_latitude, _longitude),
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
    );
  }

  void _changeMarkerPosition(LatLng pos)
  {
    setState(() {
      _latitude = pos.latitude;
      _longitude = pos.longitude;
    });
  }
}