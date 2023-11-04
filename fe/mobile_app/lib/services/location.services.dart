
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Location
{
  static Future<Position> getLatLongPosition() async
  {
    return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static Future<Address> getFullAddress(double latitude, double longitude) async
  {
    Coordinates coordinates = new Coordinates(latitude, longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  static Future<dynamic> getLocation() async
  {
    var position = await getLatLongPosition();
    Coordinates coordinates = new Coordinates(position.latitude, position.longitude);
    var adresa = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var prva = adresa.first;

    Map<String, dynamic> fullPosition = Map<String, dynamic>();
    fullPosition["textPosition"] = prva;
    fullPosition["latitude"] = coordinates.latitude;
    fullPosition["longitude"] = coordinates.longitude;
    return fullPosition;
  }
}