import 'package:aurora_watcher/data/station.dart';
import 'package:aurora_watcher/data/weather.dart';
import 'package:aurora_watcher/util/fmi_station_util.dart';
import 'package:aurora_watcher/util/latlon_util.dart';
import 'package:aurora_watcher/util/location_util.dart';
import 'package:aurora_watcher/util/weather_util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherRepository {
  WeatherRepository._internal();

  static final WeatherRepository _instance = WeatherRepository._internal();

  factory WeatherRepository() => _instance;

  Station? station;
  Weather? weather;

  Future<Weather?> getWeather(bool resetStation) async {
    final position = await LocationUtil.getCurrentLocation();
    if (position != null) {
      bool userMoved = await hasUserMoved(position);
      if (userMoved || resetStation) {
        await fetchNearestStation(position);

        FmiStationUtil.saveStation(station!);
        LocationUtil.saveUserLocation(position.latitude, position.longitude);

        weather = await WeatherUtil.fetchLatestObservation(
          fmisid: station!.fmisid,
        );
        return weather;
      }
    }

    if (!weatherExpired()) {
      return weather;
    }

    await fetchWeatherFromSavedStation();
    return weather;
  }

  bool weatherExpired() {
    if (weather != null) {
      return (DateTime.now().difference(weather!.time) > Duration(minutes: 10));
    }
    return true;
  }

  Future<void> fetchWeatherFromSavedStation() async {
    station = await FmiStationUtil.loadStation();
    if (station != null) {
      weather = await WeatherUtil.fetchLatestObservation(
        fmisid: station!.fmisid,
      );
    } else {
      weather = await WeatherUtil.fetchLatestObservation();
    }
  }

  Future<bool> hasUserMoved(Position position) async {
    double? savedUserLat = await LocationUtil.loadUserLatitude();
    double? savedUserLon = await LocationUtil.loadUserLongitude();
    if (savedUserLat == null || savedUserLon == null) {
      return true;
    }

    final moveDistance = LatlonUtil.haversine(
      position.latitude,
      position.longitude,
      savedUserLat,
      savedUserLon,
    );

    const double moveTresholdKm = 15.0;
    return moveDistance > moveTresholdKm;
  }

  Future<void> fetchNearestStation(Position position) async {
    final stations = await FmiStationUtil.fetchStations();
    station = FmiStationUtil.findNearestStation(
      position.latitude,
      position.longitude,
      stations,
    );
  }
}
