import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Luokka databasen tietojen ja topiccien käsittelyyn
class DatabaseService {
  static final FirebaseDatabase
  _firebaseDatabase = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://aurora-watcher-613b1-default-rtdb.europe-west1.firebasedatabase.app',
  );

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Datan haku databasesta
  Future<DataSnapshot?> read({required String path}) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists ? snapshot : null;
  }

  // Topicin subscriptionin eli ilmoitusten vastaanottamisen togglettaminen
  Future<void> toggleSubscription({required String stationCode}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? currentStationCode = prefs.getString('station_code');

    try {
      // Tarkistetaan, onko subscribattu topicciin ja unscriptataan siitä pois
      if (currentStationCode != null && currentStationCode.isNotEmpty) {
        await _fcm.unsubscribeFromTopic(currentStationCode);
        await prefs.remove('station_code');
        print("Unsubscribed from topic: $currentStationCode");
        return;
      }

      // Muussa tapauksessa subscipataan lähimmän revontuliaseman topicciin
      await _fcm.subscribeToTopic(stationCode);
      await prefs.setString('station_code', stationCode);
      print("Subscribed to topic: $stationCode");
    } catch (e) {
      print("Error on subscription toggle: $e");
    }
  }

  // Palautetaan true, jos on subscribattu jo johonkin topicciin
  Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    final stationCode = prefs.getString('station_code');

    return stationCode != null && stationCode.isNotEmpty;
  }
}
