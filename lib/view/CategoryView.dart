import 'package:fintracker/imdb.dart';
import 'package:fintracker/main.dart';
import 'package:fintracker/model/category.dart';
import 'package:fintracker/view/category_name_editor.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final _createFormKey = GlobalKey<FormState>();
  final _newCategoryController = TextEditingController();

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, {Category? editingCategory}) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter a category name';
    if (name.length > 50) return 'Use 20 characters or fewer';

    final alreadyExists = Imdb.categoryList.any((category) {
      return !identical(category, editingCategory) &&
          category.name.trim().toLowerCase() == name.toLowerCase();
    });
    if (alreadyExists) return 'A category with this name already exists';
    return null;
  }

  void _createCategory() {
    if (Imdb.categoryList.length >= MyApp.category_limit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You can have up to ${MyApp.category_limit} categories',
          ),
        ),
      );
      return;
    }
    if (!_createFormKey.currentState!.validate()) return;

    setState(() {
      Imdb.categoryList.add(Category(_newCategoryController.text.trim()));
      _newCategoryController.clear();
    });
  }

  void _saveCategory(Category category, String value) {
    final error = _validateName(value, editingCategory: category);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => category.name = value.trim());
  }

  void _deleteCategory(Category category) {
    final hasExpenses = Imdb.expensesList.any(
      (expense) => identical(expense.category, category),
    );
    if (hasExpenses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This category is used by expenses')),
      );
      return;
    }

    setState(() => Imdb.categoryList.remove(category));
  }

  @override
  Widget build(BuildContext context) {
    final categories = Imdb.categoryList.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _createFormKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _newCategoryController,
                    decoration: const InputDecoration(),
                    textInputAction: TextInputAction.done,
                    maxLength: 20,
                    validator: (value) => _validateName(value),
                    onFieldSubmitted: (_) => _createCategory(),
                  ),
                ),
                IconButton(
                  onPressed: _createCategory,
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                child: CategoryNameEditor(
                  key: ObjectKey(category),
                  category: category,
                  validateName: (value) =>
                      _validateName(value, editingCategory: category),
                  onSave: (value) => _saveCategory(category, value),
                  onDelete: () => _deleteCategory(category),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
