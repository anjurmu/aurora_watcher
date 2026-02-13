// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'RevontuliVahti';

  @override
  String get home => 'Koti';

  @override
  String get watcher => 'Vahti';

  @override
  String get myLocation => 'Oma Paikka';

  @override
  String get weatherStation => 'Sääasema:';

  @override
  String get temperature => 'Lämpötila:';

  @override
  String get cloudiness => 'Pilvisyys:';

  @override
  String get noAurora => 'Revontulet epätodennäköisiä';

  @override
  String get lowAurora => 'Pieni mahdollisuus revontulille';

  @override
  String get moderateAurora => 'Kohtalainen mahdollisuus revontulille';

  @override
  String get highAurora => 'Suuri mahdollisuus revontulille';

  @override
  String get noAuroraData => 'Ei revontulitietoja';
}
