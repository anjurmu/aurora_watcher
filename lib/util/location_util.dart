import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // metrin tarkkuudella päivitys
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  static Future<void> saveUserLocation(
    double latitude,
    double longitude,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('user_lat', latitude);
    await prefs.setDouble('user_lon', longitude);
  }

  static Future<double?> loadUserLatitude() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble('user_lat');
  }

  static Future<double?> loadUserLongitude() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble('user_lon');
  }
}
