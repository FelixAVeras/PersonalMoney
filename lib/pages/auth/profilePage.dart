import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/AuthWrapper.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/helpers/theme/appColorsTheme.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/UserModel.dart';
import 'package:personalmoney/pages/settings/settingPage.dart';
import 'package:personalmoney/services/authService.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SQLHelper sqlHelper = SQLHelper();
  FormatHelper formatHelper = FormatHelper();

  UserModel? user;

  double? _initialAmount;

  bool _loading = true;

  Future<void> loadUser() async {
    final u = await AuthService.getUser();

    setState(() => user = u);
  }

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

    loadUser();
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
                    title: Text(user!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user!.plan.toUpperCase()),
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
                    title: Text(_initialAmount != null
                    ? formatHelper.formatAmount(_initialAmount!)
                    : AppLocalizations.of(context)!.noPrincipalIncomeMsg, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(AppLocalizations.of(context)!.principalIncome),
                    trailing: IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.edit, color: Colors.teal), 
                      tooltip: AppLocalizations.of(context)!.edit
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.signOut),
                    content: Text(AppLocalizations.of(context)!.confirmSignOut),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style:  TextButton.styleFrom(
                          foregroundColor: AppColors.danger
                        ),
                        child: Text(AppLocalizations.of(context)!.signOut),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await AuthService.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => AuthWrapper()),
                    (route) => false,
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.danger), 
              child: Text(AppLocalizations.of(context)!.signOut)
            )
          ],
        ),
      ),
    );
  }
}