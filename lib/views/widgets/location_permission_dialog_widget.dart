import 'package:app_settings/app_settings.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LocationPermissionDialogWidget extends StatelessWidget {
  const LocationPermissionDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.locationPermissionTitle),
      content: Text(loc.locationPermissionContent),
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
