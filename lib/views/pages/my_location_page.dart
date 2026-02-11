import 'package:aurora_watcher/data/station.dart';
import 'package:aurora_watcher/data/weather.dart';
import 'package:aurora_watcher/data/weather_repository.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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

  final WeatherRepository _weatherRepository = WeatherRepository();

  @override
  void initState() {
    super.initState();
    loadWeather(false);
  }

  Future<void> loadWeather(bool resetStation) async {
    try {
      weather = await _weatherRepository.getWeather(resetStation);
      station = _weatherRepository.station;

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
                    setState(() {
                      loading = true;
                      loadWeather(true);
                    });
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
