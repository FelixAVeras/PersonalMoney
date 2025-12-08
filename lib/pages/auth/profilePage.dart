import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/pages/settingPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SQLHelper sqlHelper = SQLHelper();
  FormatHelper formatHelper = FormatHelper();

  double? _initialAmount;

  bool _loading = true;

  Future<void> loadInitialAmount() async {
    final now = DateTime.now();
    double? amount = await sqlHelper.getTotalMonthlyBudget(now.month, now.year);

    setState(() {
      _initialAmount = amount;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    loadInitialAmount();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userProfile),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())), 
            icon: Icon(Icons.settings), 
            tooltip: AppLocalizations.of(context)!.settings
          ),
        ],
      ),
      body: _loading 
      ? Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Card.outlined(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('UP'),
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.red.shade200,
                    ),
                    title: Row(
                      children: [
                        Text('Nombre Usuario', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {}, 
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                          icon: Icon(Icons.image),
                          label: Text(AppLocalizations.of(context)!.changeImage)
                        )
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange,
                          ),
                          icon: Icon(Icons.edit_document),
                          label: Text(AppLocalizations.of(context)!.editInfo)
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Card.outlined(
              child: Column(
                children: [
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.principalIncome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_initialAmount != null
                          ? formatHelper.formatAmount(_initialAmount!)
                          : AppLocalizations.of(context)!.noPrincipalIncomeMsg),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.red), 
              child: Text(AppLocalizations.of(context)!.signOut)
            )
          ],
        ),
      ),
    );
  }
}