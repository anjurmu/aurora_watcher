import 'package:aurora_watcher/data/aurora.dart';
import 'package:aurora_watcher/util/database_service.dart';
import 'package:aurora_watcher/util/latlon_util.dart';
import 'package:aurora_watcher/util/location_util.dart';

class AuroraRepository {
  AuroraRepository._internal();

  static final AuroraRepository _instance = AuroraRepository._internal();

  factory AuroraRepository() => _instance;

  Aurora? aurora;

  Future<Aurora?> getAurora() async {
    if (aurora == null) {
      aurora = await getClosestAurora();
      return aurora;
    }

    if (DateTime.now().difference(aurora!.updatetAt) > Duration(minutes: 5)) {
      aurora = await getClosestAurora();
    }

    return aurora;
  }

  Future<Aurora?> getClosestAurora() async {
    final position = await LocationUtil.getCurrentLocation();
    if (position == null) {
      return null;
    }

    final snapshot = await DatabaseService().read(path: "aurora");

    if (snapshot == null) {
      return null;
    }

    final Map<dynamic, dynamic> auroraData =
        snapshot.value as Map<dynamic, dynamic>;

    dynamic nearestStationData;
    String nearestStationCode = "";
    double minDistance = double.infinity;

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
