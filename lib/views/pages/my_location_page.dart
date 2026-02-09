import 'package:aurora_watcher/l10n/app_localizations.dart';
import 'package:aurora_watcher/util/location_util.dart';
import 'package:flutter/material.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({super.key});

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    final position = await LocationUtil.getCurrentLocation();
    if (position != null) {
      print(position.latitude);
      print(position.longitude);
    } else {
      print("Location ei toimi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/aurora_background_2_1080x1920.webp"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.35),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Text(AppLocalizations.of(context)!.myLocation),
      ),
    );
  }
}
