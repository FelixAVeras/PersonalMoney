import 'package:flutter/material.dart';
import 'package:personalmoney/l10n/app_localizations.dart';

class CategoryLocalizationHelper {
  static String translateCategory(BuildContext context, String category) {
    final loc = AppLocalizations.of(context)!;

    switch (category) {
      case 'Home':
        return loc.categoryHome;
      case 'Entertainment':
        return loc.categoryEntertainment;
      case 'Food':
        return loc.categoryFood;
      case 'Charity':
        return loc.categoryCharity;
      case 'Utilities':
        return loc.categoryUtilities;
      case 'Auto':
        return loc.categoryAuto;
      case 'Education':
        return loc.categoryEducation;
      case 'Health & Wellness':
        return loc.categoryHealth;
      case 'Shopping':
        return loc.categoryShopping;
      case 'Others':
        return loc.categoryOthers;
      default:
        return category;
    }
  }
}
