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
  String get watcherOff => 'Watcher is off';

  @override
  String get watcherOn => 'Watcher is on';

  @override
  String get fmiSource => 'Weather observations (temperature and cloudiness): ';

  @override
  String get fmiSourceLink => '© Finnish Meteorological Institute (FMI), open data';

  @override
  String get auroraSource => 'Aurora data: ';

  @override
  String get auroraSrouceLink => '© Finnish Meteorological Institute - Space Weather';

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

  @override
  String get notificationPermissionTitle => 'Notifications disabled';

  @override
  String get notificationPermissionContent => 'Please allow notifications from the app settings to reveive alerts.';

  @override
  String get cancel => 'Cancel';

  @override
  String get openSettings => 'Open settings';

  @override
  String get locationPermissionTitle => 'Location disabled';

  @override
  String get locationPermissionContent => 'Please allow device\'s location from the app settings.';

  @override
  String get watcherDescription => 'Sends notification when there is moderate or higher chance for aurora in closest Aurora station.';

  @override
  String get closestAurora => 'Closest Aurora station: ';

  @override
  String get locationDisabled => 'Location disabled, please allow app to use device\'s location to use Watcher.';
}
