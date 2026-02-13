// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aurora Watcher';

  @override
  String get home => 'Home';

  @override
  String get watcher => 'Watcher';

  @override
  String get myLocation => 'My Location';

  @override
  String get weatherStation => 'Weather station:';

  @override
  String get temperature => 'Temperature:';

  @override
  String get cloudiness => 'Cloudiness:';

  @override
  String get noAurora => 'Aurora unlikely';

  @override
  String get lowAurora => 'Low chance for aurora';

  @override
  String get moderateAurora => 'Moderate chance for aurora';

  @override
  String get highAurora => 'High chance for aurora';

  @override
  String get noAuroraData => 'Missing aurora data';
}
