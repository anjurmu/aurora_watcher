import 'package:aurora_watcher/data/aurora.dart';
import 'package:aurora_watcher/data/aurora_repository.dart';
import 'package:aurora_watcher/data/constants.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:aurora_watcher/util/database_service.dart';
import 'package:aurora_watcher/util/location_util.dart';
import 'package:aurora_watcher/util/notification_util.dart';
import 'package:aurora_watcher/views/widgets/location_permission_dialog_widget.dart';
import 'package:aurora_watcher/views/widgets/notification_permission_dialog_widget.dart';
import 'package:flutter/material.dart';

class WatcherPage extends StatefulWidget {
  const WatcherPage({super.key});

  @override
  State<WatcherPage> createState() => _WatcherPageState();
}

class _WatcherPageState extends State<WatcherPage> {
  bool isSubscribed = false;
  Aurora? aurora;
  bool loading = true;
  bool locationPermission = false;
  String? error;

  final AuroraRepository _auroraRepository = AuroraRepository();

  @override
  void initState() {
    super.initState();
    loadAurora();
    loadState();
  }

  // Ladataan revontulitiedot databasesta
  Future<void> loadAurora() async {
    try {
      // Tarkistetaan, onko lupaa käyttää laitteen sijaintia
      final hasPermission = await LocationUtil.handleLocationPermission();
      if (!mounted) return;
      if (!hasPermission) {
        locationPermission = false;
        setState(() {
          loading = false;
        });
        return;
      }
      locationPermission = true;

      aurora = await _auroraRepository.getAurora();
      if (!mounted) return;
      if (aurora == null) {
        error = "No aurora data";
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  // Katsotaan, onko vahti jo päällä
  Future<void> loadState() async {
    final subscribed = await DatabaseService().isSubscribed();
    if (!mounted) return;
    setState(() {
      isSubscribed = subscribed;
    });
  }

  // Laitetaan vahti päälle/pois
  Future<void> toggle(BuildContext context) async {
    // Tarkistetaan onko lupa lähettää ilmoituksia
    final bool notificationPermission =
        await NotificationUtil.checkNotificationPermission();
    if (!mounted) return;
    if (!notificationPermission) {
      // ignore: use_build_context_synchronously
      await showNotificationPermissionDialog(context);
      if (!mounted) return;
      return;
    }
    await DatabaseService().toggleSubscription(
      stationCode: aurora!.stationCode,
    );
    if (!mounted) return;
    loadState();
  }

  // Näyttää dialogin, josta voi mennä sovelluksen asetuksiin ja lupiin
  Future<void> showNotificationPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => NotificationPermissionDialogWidget(),
    );
  }

  // Näyttää dialogin, josta voi mennä sovelluksen asetuksiin ja lupiin
  Future<void> showLocationPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => LocationPermissionDialogWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (loading) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Text("Error: $error"),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/aurora_background_3_1080x1920.webp"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.35),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              loc.watcher,
              style: KTextStyle.titleText,
            ),
            SizedBox(height: 10),
            Transform.scale(
              scale: 1.5,
              child: Switch(
                value: isSubscribed,
                onChanged: locationPermission
                    ? (value) => toggle(context)
                    : null,
              ),
            ),
            SizedBox(height: 15),
            Text(
              loc.watcherDescription,
              style: KTextStyle.descriptionText,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            if (locationPermission) ...[
              Text(
                loc.closestAurora,
                style: KTextStyle.infoText,
                textAlign: TextAlign.center,
              ),
              Text(
                aurora!.name,
                style: KTextStyle.infoText,
              ),
            ],
            if (!locationPermission) ...[
              Text(
                loc.locationDisabled,
                style: KTextStyle.infoText,
              ),
              IconButton(
                onPressed: () => showLocationPermissionDialog(context),
                icon: Icon(Icons.settings),
                iconSize: 50,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
