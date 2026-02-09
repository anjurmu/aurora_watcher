import 'package:geolocator/geolocator.dart';

class LocationUtil {
  // Kysyy luvan ja palauttaa true/false
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Hakee sijainnin, kysyy luvan tarvittaessa
  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return null;

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, // nyt osa settings
      distanceFilter: 10, // metrin tarkkuudella päivitys
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }
}
