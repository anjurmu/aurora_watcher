import 'package:aurora_watcher/data/weather.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class WeatherUtil {
  static Future<Weather> fetchLatestObservation(int fmisid) async {
    final now = truncateToMinutes(DateTime.now().toUtc());
    final startTime = truncateToMinutes(now.subtract(const Duration(hours: 2)));

    final url = Uri.parse(
      'https://opendata.fmi.fi/wfs'
      '?service=WFS'
      '&version=2.0.0'
      '&request=GetFeature'
      '&storedquery_id=fmi::observations::weather::simple'
      '&fmisid=$fmisid'
      '&parameters=t2m,N'
      '&starttime=${startTime.toIso8601String()}'
      '&endtime=${now.toIso8601String()}',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('HTTP error ${response.statusCode}');
    }

    final document = XmlDocument.parse(response.body);

    final Map<DateTime, double> t2mMap = {};
    final Map<DateTime, int?> cloudMap = {};

    // fmi::observations::weather::simple palauttaa BsWfsElementtejä
    final elements = document.findAllElements('BsWfsElement', namespace: '*');

    for (final element in elements) {
      final timeStr = element
          .findAllElements('Time', namespace: '*')
          .first
          .innerText;
      final name = element
          .findAllElements('ParameterName', namespace: '*')
          .first
          .innerText;
      final valueStr = element
          .findAllElements('ParameterValue', namespace: '*')
          .first
          .innerText;

      //if (valueStr.toLowerCase() == 'nan') continue;

      final time = truncateToMinutes(DateTime.parse(timeStr));
      final value = double.tryParse(valueStr);

      if (value == null) continue;

      if (name == 't2m') {
        t2mMap[time] = value;
      } else if (name == 'N') {
        if (valueStr.toLowerCase() == 'nan') {
          cloudMap[time] = null;
        } else {
          cloudMap[time] = value.round();
        }
      }
    }

    // Etsitään yhteiset aikaleimat ja lajitellaan ne (uusin viimeiseksi)
    final commonTimes =
        t2mMap.keys.where((t) => cloudMap.containsKey(t)).toList()..sort();

    if (commonTimes.isEmpty) {
      throw Exception(
        'Ei yhteisiä havaintoja (t2m: ${t2mMap.length}, N: ${cloudMap.length})',
      );
    }

    final latestTime = commonTimes.last;

    return Weather(
      time: latestTime,
      temperature: t2mMap[latestTime]!,
      cloudiness: cloudMap[latestTime],
    );
  }

  static DateTime truncateToMinutes(DateTime dt) {
    return DateTime.utc(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
    );
  }
}
