import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/CategoryModel.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final SQLHelper _sqlHelper = SQLHelper();
  final FormatHelper formatHelper = FormatHelper();
  
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<CategoryModel> categories = await _sqlHelper.getCategories();
    setState(() {
      _categories = categories;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.category),
        actions: [
          IconButton(
            onPressed: () async {
              // await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBudgetPage()));
            },
            icon: const Icon(Icons.add_circle),
            tooltip: 'Add Category',
          ),
        ],
      ),
      body: _categories.isEmpty
        ? Center(child: Text("No categories found"))
        : ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              
              return ListTile(
                leading: Icon(formatHelper.getCategoryIcon(cat.name)),
                title: Text(CategoryLocalizationHelper.translateCategory(context, cat.name)),
                // subtitle: Text(cat.type),
              );
            },
          ),
    );
  }
}
