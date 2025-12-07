// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'E-mail Address';

  @override
  String get invalidEmailMsg => 'Insert a valid email';

  @override
  String get password => 'Password';

  @override
  String get emptyPasswordMsg => 'Insert a password';

  @override
  String get btnEnter => 'Enter';

  @override
  String get btnRegister => 'Register User';

  @override
  String get overview => 'Overview';

  @override
  String get profile => 'Profile';

  @override
  String get transactions => 'Transactions';

  @override
  String get budget => 'Budget';

  @override
  String get trends => 'Trends';

  @override
  String get signOut => 'Sign Out';

  @override
  String get category => 'Category';

  @override
  String get spent => 'Spent';

  @override
  String get balance => 'Balance';

  @override
  String get addTransactionTitle => 'Add Transactions';

  @override
  String get emptyTransactionMsg => 'No Transactions';

  @override
  String get chooseCategory => 'Choose a category';

  @override
  String get emptyCategory => 'You must choose a category';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Coffee, new shoes, etc...';

  @override
  String get emptyDescriptionMsg => 'Insert description';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get amount => 'Amount';

  @override
  String get emptyAmountMsg => 'Insert a valid amount';

  @override
  String get transactionSaved => 'Transaction Saved';

  @override
  String get errorSavingTransactionMsg => 'Error saving transaction';

  @override
  String get btnSaveChanges => 'Save Changes';

  @override
  String get detailTransactionTitle => 'Detail Transaction';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';
}
