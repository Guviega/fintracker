import 'package:fintracker/database/database_helper.dart';
import 'package:fintracker/model/category.dart';
import 'package:fintracker/view/category_name_editor.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  static const categoryLimit = 12;

  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final _createFormKey = GlobalKey<FormState>();
  final _newCategoryController = TextEditingController();
  List<Category> _categories = [];
  bool _isLoading = true;
  bool _hasLoadError = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await DatabaseHelper.instance.getCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoading = false;
        _hasLoadError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasLoadError = true;
      });
    }
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter a category name';
    if (name.length > 20) return 'Use 20 characters or fewer';
    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _createCategory() async {
    if (!_createFormKey.currentState!.validate()) return;

    final database = DatabaseHelper.instance;
    final categoryCount = await database.getCategoryCount();
    if (categoryCount >= CategoryView.categoryLimit) {
      _showMessage(
        'You can have up to ${CategoryView.categoryLimit} categories',
      );
      return;
    }

    final name = _newCategoryController.text.trim();
    if (!await database.isCategoryNameAvailable(name)) {
      _showMessage('A category with this name already exists');
      return;
    }

    try {
      await database.insertCategory(Category(name));
      _newCategoryController.clear();
      await _loadCategories();
    } catch (_) {
      _showMessage('Could not save the category');
    }
  }

  Future<bool> _saveCategory(Category category, String value) async {
    final error = _validateName(value);
    if (error != null) {
      _showMessage(error);
      return false;
    }

    final name = value.trim();
    final database = DatabaseHelper.instance;
    if (!await database.isCategoryNameAvailable(
      name,
      excludingCategoryId: category.id,
    )) {
      _showMessage('A category with this name already exists');
      return false;
    }

    try {
      await database.updateCategory(Category(name, id: category.id));
      category.name = name;
      await _loadCategories();
      return true;
    } catch (_) {
      _showMessage('Could not update the category');
      return false;
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final id = category.id;
    if (id == null) return;

    try {
      final wasDeleted = await DatabaseHelper.instance.deleteCategory(id);
      if (!wasDeleted) {
        _showMessage('This category is used by expenses');
        return;
      }
      await _loadCategories();
    } catch (_) {
      _showMessage('Could not delete the category');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    validator: _validateName,
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasLoadError
              ? Center(
                  child: TextButton(
                    onPressed: _loadCategories,
                    child: const Text('Could not load categories. Retry.'),
                  ),
                )
              : _categories.isEmpty
              ? const Center(child: Text('No categories yet. Add one above.'))
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CategoryNameEditor(
                        key: ValueKey(category.id),
                        category: category,
                        validateName: _validateName,
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
