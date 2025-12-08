import 'package:flutter/material.dart';
import 'package:personalmoney/l10n/app_localizations.dart';

class TrendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trends),
      ),
      body: Center(child: Text('Pantalla de Tendencias')),
    );
  }
}