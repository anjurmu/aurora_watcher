import 'package:aurora_watcher/data/aurora.dart';
import 'package:aurora_watcher/data/aurora_repository.dart';
import 'package:aurora_watcher/data/constants.dart';
import 'package:aurora_watcher/data/station.dart';
import 'package:aurora_watcher/data/weather.dart';
import 'package:aurora_watcher/data/weather_repository.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:aurora_watcher/util/location_util.dart';
import 'package:aurora_watcher/views/widgets/location_permission_dialog_widget.dart';
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
  bool locationPermission = false;
  String? error;
  String? forecastIcon;

  final WeatherRepository _weatherRepository = WeatherRepository();
  final AuroraRepository _auroraRepository = AuroraRepository();

  @override
  void initState() {
    super.initState();
    loadLocationInfo();
  }

  Future<void> loadLocationInfo() async {
    final hasPermission = await LocationUtil.handleLocationPermission();
    if (!hasPermission) {
      locationPermission = false;
      setState(() {
        loadingWeather = false;
        loadingAurora = false;
      });
      return;
    }
    locationPermission = true;

    loadWeather(false);
    loadAurora();
  }

  Future<void> showLocationPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => LocationPermissionDialogWidget(),
    );
  }

  Future<void> loadWeather(bool resetStation) async {
    try {
      weather = await _weatherRepository.getWeather(resetStation);
      station = _weatherRepository.station;

      setForecastIcon();

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

  void setForecastIcon() {
    if (weather != null) {
      if (weather?.cloudiness == null) {
        forecastIcon = null;
      } else {
        switch (weather!.cloudiness!) {
          case >= 0 && <= 1:
            forecastIcon = "assets/images/sunny_forecast_icon.png";
          case >= 2 && <= 5:
            forecastIcon = "assets/images/partly_cloudy_forecast_icon.png";
          case >= 6 && <= 8:
            forecastIcon = "assets/images/cloudy_forecast_icon.png";
          default:
            forecastIcon = null;
        }
      }
    }
  }

  Text getAuroraChance(BuildContext context) {
    if (aurora != null) {
      if (aurora!.rValue != null) {
        // Kohtalainen mahdollisuus asetetaan ala ja ylärajan puoliväliin
        int moderateChance =
            aurora!.lowerLimit + (aurora!.upperLimit - aurora!.lowerLimit) ~/ 2;

        if (aurora!.rValue! >= aurora!.upperLimit) {
          return Text(
            AppLocalizations.of(context)!.highAurora,
            style: TextStyle(color: Colors.red, fontSize: 26),
          );
        } else if (aurora!.rValue! >= moderateChance) {
          return Text(
            AppLocalizations.of(context)!.moderateAurora,
            style: TextStyle(color: Colors.orange, fontSize: 26),
          );
        } else if (aurora!.rValue! >= aurora!.lowerLimit) {
          return Text(
            AppLocalizations.of(context)!.lowAurora,
            style: TextStyle(color: Colors.yellow, fontSize: 26),
          );
        } else {
          return Text(
            AppLocalizations.of(context)!.noAurora,
            style: TextStyle(color: Colors.white, fontSize: 26),
          );
        }
      }
    }

    return Text(
      AppLocalizations.of(context)!.noAuroraData,
      style: TextStyle(fontSize: 26),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
      child: Column(
        children: [
          if (!locationPermission) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loc.locationDisabled,
                        style: KTextStyle.infoText,
                      ),
                      IconButton(
                        onPressed: () => showLocationPermissionDialog(context),
                        icon: Icon(Icons.settings),
                        iconSize: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (locationPermission) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
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
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getAuroraChance(context),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        loc.weatherStation,
                        style: KTextStyle.descriptionText,
                      ),
                      Text(
                        station!.name,
                        style: KTextStyle.titleText,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        loc.temperature,
                        style: KTextStyle.infoText,
                      ),
                      Text(
                        "${weather!.temperature.toString()} °C",
                        style: TextStyle(fontSize: 40),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        loc.cloudiness,
                        style: KTextStyle.infoText,
                      ),
                      forecastIcon != null
                          ? Image.asset(
                              forecastIcon!,
                              width: 200,
                            )
                          : const Icon(
                              Icons.question_mark,
                              size: 100,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
