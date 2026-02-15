import 'package:app_settings/app_settings.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NotificationPermissionDialogWidget extends StatelessWidget {
  const NotificationPermissionDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.notificationPermissionTitle),
      content: Text(loc.notificationPermissionContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            AppSettings.openAppSettings();
          },
          child: Text(loc.openSettings),
        ),
      ],
    );
  }
}
