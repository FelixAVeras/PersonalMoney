import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/helpers/overviewHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/budgetModel.dart';
import 'package:personalmoney/pages/auth/profilePage.dart';
// import 'package:personalmoney/pages/auth/profilePage.dart';
import 'package:personalmoney/pages/budgets/budgetPage.dart';
import 'package:personalmoney/pages/overviewList.dart';
import 'package:personalmoney/pages/settings/settingPage.dart';
import 'package:personalmoney/pages/transactions/transactionPage.dart';
import 'package:personalmoney/pages/trends/trendsPage.dart';
// import 'package:personalmoney/pages/trends/trendsPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SQLHelper sqlHelper = SQLHelper();
  final OverviewHelper overviewHelper = OverviewHelper();
  final FormatHelper formatHelper = FormatHelper();
  
  List<BudgetModel> budgets = [];
  
  Map<int, String> categoryNames = {};

  List<Map<String, dynamic>> overviewData = [];

  int currentPageIndex = 0;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: [
        OverviewList(),
        TransactionPage(),
        BudgetPage(),
        TrendsPage(),
        ProfilePage()
        // SettingsPage()
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Color(0xFFF78c2ad),
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.pie_chart_rounded, color: Colors.white),
            icon: Icon(Icons.pie_chart_outline_rounded),
            label: AppLocalizations.of(context)!.overview,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.sync_alt_rounded, color: Colors.white),
            icon: Icon(Icons.sync_alt_rounded),
            label: AppLocalizations.of(context)!.transactions,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.attach_money_rounded, color: Colors.white),
            icon: Icon(Icons.attach_money_rounded),
            label: AppLocalizations.of(context)!.budget,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bar_chart_rounded, color: Colors.white),
            icon: Icon(Icons.bar_chart_rounded),
            label: AppLocalizations.of(context)!.trends,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_rounded, color: Colors.white),
            icon: Icon(Icons.person_outline_rounded),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}
