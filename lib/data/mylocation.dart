import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Mylocation {
  double? lat;
  double? lon;

  Future<void> getLocation(scity) async {

    if(scity == ''){
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        lat = position.latitude;
        lon = position.longitude;

      } catch (e) {
        print(e);
      }
    } else {
      try {
        List<Location> location = await locationFromAddress(scity);
        lat = location[0].latitude;
        lon = location[0].longitude;
      } catch (e) {
        print('internet not connect');
      }
    }

  }
}
