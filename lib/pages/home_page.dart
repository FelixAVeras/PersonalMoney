import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/helpers/overviewHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/l10n/app_localizations_en.dart';
import 'package:personalmoney/models/budgetModel.dart';
import 'package:personalmoney/pages/budgets/budgetPage.dart';
import 'package:personalmoney/pages/overviewList.dart';
import 'package:personalmoney/pages/settingPage.dart';
import 'package:personalmoney/pages/transactions/transactionPage.dart';
import 'package:personalmoney/pages/trends/trendsPage.dart';

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
      backgroundColor: Colors.grey.shade300,
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.teal,
      //         ),
      //         child: Image.asset('assets/pigbank.png', width: 128.0)
      //       ),
      //       // ListTile(
      //       //   leading: Icon(Icons.person),
      //       //   title: Text(AppLocalizations.of(context)!.profile),
      //       //   onTap: () {
      //       //     Navigator.pop(context);

      //       //     Navigator.push(
      //       //       context,
      //       //       MaterialPageRoute(builder: (context) => ProfilePage())
      //       //     );
      //       //   },
      //       // ),
      //       // const Divider(),
      //       ListTile(
      //         leading: Icon(Icons.sync_alt),
      //         title: Text(AppLocalizations.of(context)!.transactions),
      //         onTap: () {
      //           Navigator.pop(context);

      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => TransactionPage())
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.attach_money),
      //         title: Text(AppLocalizations.of(context)!.budget),
      //         onTap: () {
      //           Navigator.pop(context);

      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => BudgetPage())
      //           );
      //         },
      //       ),
      //       // const Divider(),
      //       // ListTile(
      //       //   leading: Icon(Icons.bar_chart),
      //       //   title: Text(AppLocalizations.of(context)!.trends),
      //       //   onTap: () {
                
      //       //   },
      //       // ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text(AppLocalizations.of(context)!.settings),
      //         onTap: () {
      //           Navigator.pop(context);

      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => SettingsPage())
      //           );
      //         },
      //       ),
      //       // const Divider(),
      //       // ListTile(
      //       //   leading: Icon(Icons.output),
      //       //   title: Text(AppLocalizations.of(context)!.signOut),
      //       //   onTap: () {
                
      //       //   },
      //       //   trailing: Icon(Icons.arrow_back, color: Colors.red,),
      //       // ),
      //     ],
      //   ),
      // ),
      body: [
        OverviewList(),
        TransactionPage(),
        BudgetPage(),
        TrendsPage(),
        SettingsPage()
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.teal,
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
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
            selectedIcon: Icon(Icons.settings_rounded, color: Colors.white),
            icon: Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}
