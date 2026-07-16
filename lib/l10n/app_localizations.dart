import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi')
  ];

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password:'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Aurora Watcher'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @watcher.
  ///
  /// In en, this message translates to:
  /// **'Watcher'**
  String get watcher;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get myLocation;

  /// No description provided for @watcherOff.
  ///
  /// In en, this message translates to:
  /// **'Watcher is off'**
  String get watcherOff;

  /// No description provided for @watcherOn.
  ///
  /// In en, this message translates to:
  /// **'Watcher is on'**
  String get watcherOn;

  /// No description provided for @fmiSource.
  ///
  /// In en, this message translates to:
  /// **'Weather observations (temperature and cloudiness): '**
  String get fmiSource;

  /// No description provided for @fmiSourceLink.
  ///
  /// In en, this message translates to:
  /// **'© Finnish Meteorological Institute (FMI), open data'**
  String get fmiSourceLink;

  /// No description provided for @auroraSource.
  ///
  /// In en, this message translates to:
  /// **'Aurora data: '**
  String get auroraSource;

  /// No description provided for @auroraSrouceLink.
  ///
  /// In en, this message translates to:
  /// **'© Finnish Meteorological Institute - Space Weather'**
  String get auroraSrouceLink;

  /// No description provided for @weatherStation.
  ///
  /// In en, this message translates to:
  /// **'Weather station:'**
  String get weatherStation;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature:'**
  String get temperature;

  /// No description provided for @cloudiness.
  ///
  /// In en, this message translates to:
  /// **'Cloudiness:'**
  String get cloudiness;

  /// No description provided for @noAurora.
  ///
  /// In en, this message translates to:
  /// **'Aurora unlikely'**
  String get noAurora;

  /// No description provided for @lowAurora.
  ///
  /// In en, this message translates to:
  /// **'Low chance for aurora'**
  String get lowAurora;

  /// No description provided for @moderateAurora.
  ///
  /// In en, this message translates to:
  /// **'Moderate chance for aurora'**
  String get moderateAurora;

  /// No description provided for @highAurora.
  ///
  /// In en, this message translates to:
  /// **'High chance for aurora'**
  String get highAurora;

  /// No description provided for @noAuroraData.
  ///
  /// In en, this message translates to:
  /// **'Missing aurora data'**
  String get noAuroraData;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'Please allow notifications from the app settings to reveive alerts.'**
  String get notificationPermissionContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location disabled'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'Please allow device\'s location from the app settings.'**
  String get locationPermissionContent;

  /// No description provided for @watcherDescription.
  ///
  /// In en, this message translates to:
  /// **'Sends notification when there is moderate or higher chance for aurora in closest Aurora station.'**
  String get watcherDescription;

  /// No description provided for @closestAurora.
  ///
  /// In en, this message translates to:
  /// **'Closest Aurora station: '**
  String get closestAurora;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location disabled, please allow app to use device\'s location to use Watcher.'**
  String get locationDisabled;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fi': return AppLocalizationsFi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
