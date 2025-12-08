import 'package:flutter/material.dart';
import 'package:personalmoney/l10n/app_localizations.dart';

class TrendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trends),
      ),
      body: Center(child: Text('Pantalla de Tendencias')),
    );
  }
}