import 'package:aurora_watcher/data/aurora.dart';
import 'package:aurora_watcher/util/database_service.dart';
import 'package:aurora_watcher/util/latlon_util.dart';
import 'package:aurora_watcher/util/location_util.dart';

// Luokka singletonina, jotta sen sisältämät tiedot pysyvät puhelimen välimustissa
// Helpottaa tietojen siirtämistä sivujen välillä sekä vähentämään API/database kutsuja
class AuroraRepository {
  AuroraRepository._internal();

  static final AuroraRepository _instance = AuroraRepository._internal();

  factory AuroraRepository() => _instance;

  Aurora? aurora;

  // Palauttaa revontulitiedot
  Future<Aurora?> getAurora() async {
    // Jos tietoja ei ole vielä haettu, haetaan lähimmän aseman revontulitiedot
    if (aurora == null) {
      aurora = await getClosestAurora();
      return aurora;
    }

    // Jos revontulitiedo ovat yli 5 minuuttia vanhat, haetaan ne databasesta uudestaan
    if (DateTime.now().difference(aurora!.updatetAt) > Duration(minutes: 5)) {
      aurora = await getClosestAurora();
    }

    return aurora;
  }

  // Hakee ja palauttaa lähimmän aseman revontulitiedot databasesta
  Future<Aurora?> getClosestAurora() async {
    final position =
        await LocationUtil.getCurrentLocation(); // Haetaan käyttäjän sijainti
    if (position == null) {
      return null;
    }

    // Haetaan kaikki revontulitiedot
    final snapshot = await DatabaseService().read(path: "aurora");

    if (snapshot == null) {
      return null;
    }

    final Map<dynamic, dynamic> auroraData =
        snapshot.value as Map<dynamic, dynamic>;

    dynamic nearestStationData;
    String nearestStationCode = "";
    double minDistance = double.infinity;

    // Verrataan kaikkien asemien sijaintia käyttäjän sijaintiin ja
    // tallennetaan lähimmän aseman koodi
    auroraData.forEach((stationCode, stationData) {
      final d = LatlonUtil.haversine(
        position.latitude,
        position.longitude,
        stationData["lat"],
        stationData["lon"],
      );

      if (d < minDistance) {
        minDistance = d;
        nearestStationData = stationData;
        nearestStationCode = stationCode;
      }
    });

    // Palautetaan lähimmän aseman revontulitiedot
    return Aurora(
      stationCode: nearestStationCode,
      time: DateTime.parse(nearestStationData["time"]),
      rValue: nearestStationData["rValue"],
      upperLimit: nearestStationData["upperLimit"],
      lowerLimit: nearestStationData["lowerLimit"],
      name: nearestStationData["name"],
      lat: nearestStationData["lat"],
      lon: nearestStationData["lon"],
      updatetAt: DateTime.fromMicrosecondsSinceEpoch(
        nearestStationData["updatedAt"],
      ),
    );
  }
}
