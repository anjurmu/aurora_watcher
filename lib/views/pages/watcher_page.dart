import 'package:app_settings/app_settings.dart';
import 'package:aurora_watcher/data/aurora.dart';
import 'package:aurora_watcher/data/aurora_repository.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:aurora_watcher/util/database_service.dart';
import 'package:aurora_watcher/util/notification_util.dart';
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
      aurora = await _auroraRepository.getAurora();
      if (aurora == null) {
        error = "No aurora data";
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> loadState() async {
    final subscribed = await DatabaseService().isSubscribed();
    setState(() {
      isSubscribed = subscribed;
    });
  }

  Future<void> toggle(BuildContext context) async {
    // Tarkistetaan onko lupa lähettää ilmoituksia
    final bool notificationPermission =
        await NotificationUtil.checkNotificationPermission();
    if (!notificationPermission) {
      // ignore: use_build_context_synchronously
      await showPermissionDialog(context);
      return;
    }
    await DatabaseService().toggleSubscription(
      stationCode: aurora!.stationCode,
    );
    loadState();
  }

  Future<void> showPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ilmoitukset pois käytöstä"),
        content: const Text(
          "Salli ilmoitukset sovelluksen asetuksista, jotta voit saada hälytyksiä.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Peruuta"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
            child: const Text("Avaa asetukset"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Text("Virhe: $error"),
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
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.watcher),
          Switch(
            value: isSubscribed,
            onChanged: (value) => toggle(context),
          ),
        ],
      ),
    );
  }
}
