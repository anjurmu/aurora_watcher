import 'package:aurora_watcher/data/constants.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:aurora_watcher/util/database_service.dart';
import 'package:aurora_watcher/views/widgets/source_link_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWatcherOn = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getWatcherStatus();
  }

  Future<void> getWatcherStatus() async {
    isWatcherOn = await DatabaseService().isSubscribed();
    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (loading) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/aurora_background_1080x1920.webp"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.35),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.appTitle, style: KTextStyle.titleText),
                  if (isWatcherOn)
                    Text(
                      loc.watcherOn,
                      style: KTextStyle.watcherOnText,
                    ),
                  if (!isWatcherOn)
                    Text(
                      loc.watcherOff,
                      style: KTextStyle.watcherOffText,
                    ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SourceLinkWidget(
                  sourceText: loc.fmiSource,
                  linkText: loc.fmiSourceLink,
                  url: "https://en.ilmatieteenlaitos.fi/open-data",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SourceLinkWidget(
                  sourceText: loc.auroraSource,
                  linkText: loc.auroraSrouceLink,
                  url: "https://rwc-finland.fmi.fi/",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
