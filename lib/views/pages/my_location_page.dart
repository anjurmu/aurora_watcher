import 'package:aurora_watcher/data/station.dart';
import 'package:aurora_watcher/data/weather.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:aurora_watcher/util/fmi_station_util.dart';
import 'package:aurora_watcher/util/latlon_util.dart';
import 'package:aurora_watcher/util/location_util.dart';
import 'package:aurora_watcher/util/weather_util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({super.key});

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  Weather? weather;
  Station? station;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    getWeather(false);
  }

  Future<void> getWeather(bool resetStation) async {
    try {
      final position = await LocationUtil.getCurrentLocation();
      if (position != null) {
        bool userMoved = await hasUserMoved(position);
        if (userMoved || resetStation) {
          await fetchNearestStation(position);

          FmiStationUtil.saveStation(station!);
          saveUserLocation(position.latitude, position.longitude);

          weather = await WeatherUtil.fetchLatestObservation(
            fmisid: station!.fmisid,
          );

          setState(() {
            loading = false;
          });
          return;
        }
      }

      await fetchWeather();

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> fetchWeather() async {
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
    final prefs = await SharedPreferences.getInstance();

    double? savedUserLat = prefs.getDouble('user_lat');
    double? savedUserLon = prefs.getDouble('user_lon');
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

  Future<void> saveUserLocation(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('user_lat', latitude);
    await prefs.setDouble('user_lon', longitude);
  }

  Future<void> fetchNearestStation(Position position) async {
    final stations = await FmiStationUtil.fetchStations();
    station = FmiStationUtil.findNearestStation(
      position.latitude,
      position.longitude,
      stations,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    }

    if (error != null) {
      return Text("Virhe: $error");
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/aurora_background_2_1080x1920.webp"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.35),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.myLocation,
                ),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.restart_alt),
                  onPressed: () {
                    getWeather(true);
                  },
                ),
              ],
            ),
            Text(station!.name),
            Text(weather!.temperature.toString()),
            Text(weather!.cloudiness.toString()),
            Text(weather!.time.toString()),
          ],
        ),
      ),
    );
  }
}
