// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get email => 'Sähköposti:';

  @override
  String get password => 'Salasana:';

  @override
  String get login => 'Kirjaudu';

  @override
  String get appTitle => 'RevontuliVahti';

  @override
  String get home => 'Koti';

  @override
  String get watcher => 'Vahti';

  @override
  String get myLocation => 'Oma Paikka';

  @override
  String get watcherOff => 'Vahti on pois päältä';

  @override
  String get watcherOn => 'Vahti on päällä';

  @override
  String get fmiSource => 'Säähavainnot (lämpötila ja pilvisyys): ';

  @override
  String get fmiSourceLink => '© Ilmatieteen laitos (FMI), avoin data';

  @override
  String get auroraSource => 'Revontulitiedot: ';

  @override
  String get auroraSrouceLink => '© Ilmatieteen laitos – Avaruussää';

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

  @override
  String get notificationPermissionTitle => 'Ilmoitukset pois käytöstä';

  @override
  String get notificationPermissionContent => 'Salli ilmoitukset sovelluksen asetuksista, jotta voit saada hälytyksiä.';

  @override
  String get cancel => 'Peruuta';

  @override
  String get openSettings => 'Avaa asetukset';

  @override
  String get locationPermissionTitle => 'Sijainti pois käytöstä';

  @override
  String get locationPermissionContent => 'Salli sijainnin käyttäminen sovelluksen asetuksista.';

  @override
  String get watcherDescription => 'Lähettää ilmoituksen kun revontulten mahdollisuus on kohtalainen tai korkeampi lähimmällä revontuliasemalla.';

  @override
  String get closestAurora => 'Lähin revontuliasema: ';

  @override
  String get locationDisabled => 'Sijainti pois käytöstä, anna sovelluksen käyttää laitteen sijaintia Vahdin käyttämiseen.';
}
