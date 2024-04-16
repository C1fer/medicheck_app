import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<Position> getCurrentPosition() async {
    LocationPermission permission;

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission(); // request permissions if denied
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied'); // Throw error on denied permissions upon request.
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      // Return current position when service is  enabled and permission is granted
      return await Geolocator.getCurrentPosition();
    }

    return Future.error('Location services are disabled.');
  }

}
