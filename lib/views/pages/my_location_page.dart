import 'package:aurora_watcher/data/aurora.dart';
import 'package:aurora_watcher/data/aurora_repository.dart';
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
  Aurora? aurora;
  bool loadingWeather = true;
  bool loadingAurora = true;
  String? error;

  final WeatherRepository _weatherRepository = WeatherRepository();
  final AuroraRepository _auroraRepository = AuroraRepository();

  @override
  void initState() {
    super.initState();
    loadWeather(false);
    loadAurora();
  }

  Future<void> loadWeather(bool resetStation) async {
    try {
      weather = await _weatherRepository.getWeather(resetStation);
      station = _weatherRepository.station;

      setState(() {
        loadingWeather = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loadingWeather = false;
      });
    }
  }

  Future<void> loadAurora() async {
    try {
      aurora = await _auroraRepository.getAurora();

      if (aurora == null) {
        error = "No aurora data";
      }

      setState(() {
        loadingAurora = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loadingAurora = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadingWeather || loadingAurora) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Text("Virhe: $error"),
      );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.myLocation,
                ),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.restart_alt),
                  onPressed: () {
                    setState(() {
                      loadingAurora = true;
                      loadingWeather = true;
                      loadWeather(true);
                      loadAurora();
                    });
                  },
                ),
              ],
            ),
            Text(station!.name),
            Text(weather!.temperature.toString()),
            Text(weather!.cloudiness.toString()),
            Text(weather!.time.toString()),
            Text(aurora!.rValue.toString()),
            Text(aurora!.upperLimit.toString()),
            Text(aurora!.lowerLimit.toString()),
          ],
        ),
      ),
    );
  }
}
