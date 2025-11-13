import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    this.url = "https://www.youtube.com/",
  });

  Future<void> _openUrl() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $uri";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(label),
      onTap: _openUrl, // ⬅ bấm vào mở link
    );
  }
}
