import 'package:aurora_watcher/data/station.dart';
import 'package:aurora_watcher/util/latlon_util.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class FmiStationUtil {
  static Future<List<Station>> fetchStations() async {
    final url = Uri.parse(
      'https://opendata.fmi.fi/wfs'
      '?service=WFS'
      '&version=2.0.0'
      '&request=GetFeature'
      '&storedquery_id=fmi::ef::stations',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('HTTP error ${response.statusCode}');
    }

    final document = XmlDocument.parse(response.body);
    final members = document.findAllElements('member', namespace: '*');

    final stations = <Station>[];

    for (final m in members) {
      try {
        // ef:name = aseman nimi
        final name = m
            .findAllElements('name', namespace: '*')
            .where((e) => e.name.prefix == 'ef')
            .first
            .innerText
            .trim();

        // gml:identifier = FMISID
        final fmisid = int.parse(
          m
              .findAllElements('identifier', namespace: '*')
              .first
              .innerText
              .trim(),
        );

        // gml:pos = latitude ja longitude
        final pos = m
            .findAllElements('pos', namespace: '*')
            .first
            .innerText
            .trim();

        final parts = pos.split(RegExp(r'\s+'));
        if (parts.length != 2) continue;

        final lat = double.parse(parts[0]);
        final lon = double.parse(parts[1]);

        // tarkistetaan, onko asema automaattinen sääasema
        // Etsi kaikki belongsTo-elementit
        final belongsToElements = m.findAllElements(
          'belongsTo',
          namespace: '*',
        );

        // Tarkista, löytyykö automaattinen sääasema
        final hasAutomatic = belongsToElements.any((b) {
          final titleAttr = b.getAttribute(
            'title',
            namespace: 'http://www.w3.org/1999/xlink',
          );
          return titleAttr == 'Automaattinen sääasema';
        });

        if (!hasAutomatic) {
          continue; // skipataan asema, jos ei löydy
        }

        // --- Lisätään asema listaan ---
        stations.add(
          Station(
            name: name,
            fmisid: fmisid,
            lat: lat,
            lon: lon,
          ),
        );
      } catch (_) {
        continue; // ohitetaan rikkinäinen asema
      }
    }

    if (stations.isEmpty) {
      throw Exception(
        'No stations parsed — XML structure mismatch or no automatic stations found',
      );
    }

    return stations;
  }

  static Station findNearestStation(
    double userLat,
    double userLon,
    List<Station> stations,
  ) {
    if (stations.isEmpty) {
      throw Exception('Station list is empty');
    }

    Station? nearest;
    double minDistance = double.infinity;

    for (final s in stations) {
      // latlon_util funktio
      final d = LatlonUtil.haversine(
        userLat,
        userLon,
        s.lat,
        s.lon,
      );

      if (d < minDistance) {
        minDistance = d;
        nearest = s;
      }
    }

    return nearest!;
  }

  static Future<void> saveStation(Station station) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('station_fmisid', station.fmisid);
    await prefs.setString('station_name', station.name);
    await prefs.setDouble('station_lat', station.lat);
    await prefs.setDouble('station_lon', station.lon);
  }

  static Future<Station?> loadStation() async {
    final prefs = await SharedPreferences.getInstance();

    final fmisid = prefs.getInt('station_fmisid');
    final name = prefs.getString('station_name');
    final lat = prefs.getDouble('station_lat');
    final lon = prefs.getDouble('station_lon');

    if (fmisid != null && name != null && lat != null && lon != null) {
      return Station(
        name: name,
        fmisid: fmisid,
        lat: lat,
        lon: lon,
      );
    } else {
      return null; // ei tallennettua asemaa
    }
  }
}
