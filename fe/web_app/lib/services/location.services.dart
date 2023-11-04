import 'package:geocoder/geocoder.dart';

class Location {

  static Future<Address> getFullAddress(double latitude, double longitude) async
  {
    Coordinates coordinates = new Coordinates(latitude, longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    
    return addresses.first;
  }

}
