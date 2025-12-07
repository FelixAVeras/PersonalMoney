// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get email => 'Adresse e-mail';

  @override
  String get invalidEmailMsg => 'Insérez un e-mail valide';

  @override
  String get password => 'Mot de passe';

  @override
  String get emptyPasswordMsg => 'Insérez un mot de passe';

  @override
  String get btnEnter => 'Entrer';

  @override
  String get btnRegister => 'Enregistrer l\'utilisateur';

  @override
  String get overview => 'Aperçu';

  @override
  String get profile => 'Mon Profil';

  @override
  String get transactions => 'Transactions';

  @override
  String get budget => 'Budget';

  @override
  String get trends => 'Tendances';

  @override
  String get settings => 'Paramètres';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get category => 'Catégorie';

  @override
  String get spent => 'Dépensé';

  @override
  String get balance => 'Solde';

  @override
  String get addTransactionTitle => 'Ajouter une Transaction';

  @override
  String get emptyTransactionMsg => 'Aucune transaction';

  @override
  String get chooseCategory => 'Choisissez une catégorie';

  @override
  String get emptyCategory => 'Vous devez choisir une catégorie';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Café, nouvelles chaussures, etc...';

  @override
  String get emptyDescriptionMsg => 'Insérez une description';

  @override
  String get expense => 'Dépense';

  @override
  String get income => 'Revenu';

  @override
  String get amount => 'Montant';

  @override
  String get emptyAmountMsg => 'Insérez un montant valide';

  @override
  String get transactionSaved => 'Transaction enregistrée';

  @override
  String get errorSavingTransactionMsg =>
      'Erreur lors de l\'enregistrement de la transaction';

  @override
  String get btnSaveChanges => 'Enregistrer les modifications';

  @override
  String get detailTransactionTitle => 'Détail de la Transaction';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get appTheme => 'Thème de l\'application';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Par défaut du système';

  @override
  String get language => 'Langue';
}
