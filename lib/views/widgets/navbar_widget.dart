import 'package:aurora_watcher/data/notifiers.dart';
import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            NavigationDestination(
              icon: Icon(Icons.alarm),
              label: AppLocalizations.of(context)!.watcher,
            ),
            NavigationDestination(
              icon: Icon(Icons.place),
              label: AppLocalizations.of(context)!.myLocation,
            ),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
