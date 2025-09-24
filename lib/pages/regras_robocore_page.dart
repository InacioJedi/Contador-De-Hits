import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RegrasRobocorePage extends StatelessWidget {
  const RegrasRobocorePage({super.key});

  static final Uri _pdf = Uri.parse(
      'https://robocore-eventos.s3.sa-east-1.amazonaws.com/public/Critério_Julgamento+-+Combate.pdf');

  Future<void> _open() async {
    if (!await launchUrl(_pdf, mode: LaunchMode.externalApplication)) {
      await launchUrl(_pdf, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regras Robocore'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _open,
          icon: const Icon(Icons.open_in_new),
          label: const Text('Abrir documento'),
        ),
      ),
    );
  }
}
