// Luokka revontulitietojen säilömiseen
class Aurora {
  final String stationCode;
  final DateTime time;
  final int? rValue;
  final int upperLimit;
  final int lowerLimit;
  final String name;
  final double lat;
  final double lon;
  final DateTime updatetAt;

  Aurora({
    required this.stationCode,
    required this.time,
    required this.rValue,
    required this.upperLimit,
    required this.lowerLimit,
    required this.name,
    required this.lat,
    required this.lon,
    required this.updatetAt,
  });
}
