import 'package:aurora_watcher/data/station.dart';
import 'package:aurora_watcher/data/weather.dart';
import 'package:aurora_watcher/util/fmi_station_util.dart';
import 'package:aurora_watcher/util/latlon_util.dart';
import 'package:aurora_watcher/util/location_util.dart';
import 'package:aurora_watcher/util/weather_util.dart';
import 'package:geolocator/geolocator.dart';

// Luokka singletonina, jotta sen sisältämät tiedot pysyvät puhelimen välimustissa
// Helpottaa tietojen siirtämistä sivujen välillä sekä vähentämään API/database kutsuja
class WeatherRepository {
  WeatherRepository._internal();

  static final WeatherRepository _instance = WeatherRepository._internal();

  factory WeatherRepository() => _instance;

  Station? station;
  Weather? weather;

  // Palauttaa säätieot
  Future<Weather?> getWeather(bool resetStation) async {
    // Haetaan käyttäjän sijainti ja haetaan säätiedot uudestaan,
    // jos sijainti on muuttunut tarpeeksi tai resetStation on True
    final position = await LocationUtil.getCurrentLocation();
    if (position != null) {
      bool userMoved = await hasUserMoved(position);
      if (userMoved || resetStation) {
        await fetchNearestStation(position);

        weather = await WeatherUtil.fetchLatestObservation(
          station!.fmisid,
        );

        // Tallennetaan sääasema ja käyttäjän sijainti preferenceihin,
        // jotta sääasemaa ei tarvitse hakea aina uudelleen
        FmiStationUtil.saveStation(station!);
        LocationUtil.saveUserLocation(position.latitude, position.longitude);

        return weather;
      }
    } else {
      return null;
    }

    // Jos sään viime hausta on kulunut liian vähän aikaa,
    // palautetaan välimuistissa oleva säätieto
    if (!weatherExpired() && weather != null) {
      return weather;
    }

    // Hakee preferenceihin tallennetun sääaseman säätiedot
    await fetchWeatherFromSavedStation();
    return weather;
  }

  // Katsoo, onko viime sään API hausta kulunut yli 10 min
  bool weatherExpired() {
    if (weather != null) {
      return (DateTime.now().difference(weather!.time) > Duration(minutes: 10));
    }
    return true;
  }

  // Hakee tallennetun sääaseman säätiedot
  Future<void> fetchWeatherFromSavedStation() async {
    station = await FmiStationUtil.loadStation();
    if (station != null) {
      weather = await WeatherUtil.fetchLatestObservation(
        station!.fmisid,
      );
    } else {
      weather = null;
    }
  }

  // Laskee, kuinka paljon käyttäjä on liikkunut viime säätietojen API kutsuun verrattuna
  // Jos käyttäjä liikkunut yli 15km palauttaa true
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

  // Noutaa sääasemalistan FMI API:sta ja hakee hakee käyttäjää lähimpänä olevan
  Future<void> fetchNearestStation(Position position) async {
    final stations = await FmiStationUtil.fetchStations();
    station = FmiStationUtil.findNearestStation(
      position.latitude,
      position.longitude,
      stations,
    );
  }
}
