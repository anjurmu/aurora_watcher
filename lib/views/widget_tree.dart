import 'package:aurora_watcher/data/notifiers.dart';
import 'package:aurora_watcher/views/pages/home_page.dart';
import 'package:aurora_watcher/views/pages/my_location_page.dart';
import 'package:aurora_watcher/views/pages/watcher_page.dart';
import 'package:aurora_watcher/views/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [HomePage(), WatcherPage(), MyLocationPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aurora Watcher"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages[selectedPage];
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
