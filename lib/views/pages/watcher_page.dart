import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:aurora_watcher/util/database_service.dart';
import 'package:flutter/material.dart';

class WatcherPage extends StatelessWidget {
  const WatcherPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          FilledButton(
            onPressed: () async {
              final snapshot = await DatabaseService().read(path: "data");
              print(snapshot?.value);
            },
            child: Text("Get data1"),
          ),
        ],
      ),
    );
  }
}
