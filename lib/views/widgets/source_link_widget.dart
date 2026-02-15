import 'package:aurora_watcher/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceLinkWidget extends StatelessWidget {
  final String sourceText;
  final String linkText;
  final String url;

  const SourceLinkWidget({
    super.key,
    required this.sourceText,
    required this.linkText,
    required this.url,
  });

  Future<void> openUrl() async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          sourceText,
          style: TextStyle(fontSize: 14),
        ),
        GestureDetector(
          onTap: openUrl,
          child: Text(
            linkText,
            style: KTextStyle.linkText,
          ),
        ),
      ],
    );
  }
}
