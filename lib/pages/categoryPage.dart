import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/CategoryModel.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final SQLHelper _sqlHelper = SQLHelper();
  
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
        title: Text('Categories'),
      ),
      body: _categories.isEmpty
        ? Center(child: Text("No categories found"))
        : ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              
              return ListTile(
                leading: Icon(getCategoryIcon(cat.name)),
                title: Text(cat.name),
                // subtitle: Text(cat.type),
              );
            },
          ),
    );
  }

  IconData getCategoryIcon(String name) {
    switch (name) {
      case 'Home':
        return Icons.home;
      case 'Entertainment':
        return Icons.movie;
      case 'Food':
        return Icons.restaurant;
      case 'Charity':
        return Icons.volunteer_activism;
      case 'Utilities':
        return Icons.lightbulb;
      case 'Auto':
        return Icons.directions_car;
      case 'Education':
        return Icons.school;
      case 'Health & Wellness':
        return Icons.health_and_safety;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Others':
      default:
        return Icons.question_mark;
    }
  }
}
