import 'package:fintracker/imdb.dart';
import 'package:fintracker/model/category.dart';
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
    if (name.length > 50) return 'Use 50 characters or fewer';

    final alreadyExists = Imdb.categoryList.any((category) {
      return !identical(category, editingCategory) &&
          category.name.trim().toLowerCase() == name.toLowerCase();
    });
    if (alreadyExists) return 'A category with this name already exists';
    return null;
  }

  void _createCategory() {
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
                child: _CategoryNameEditor(
                  key: ObjectKey(category),
                  category: category,
                  validateName: (value) =>
                      _validateName(value, editingCategory: category),
                  onSave: (value) => _saveCategory(category, value),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryNameEditor extends StatefulWidget {
  const _CategoryNameEditor({
    super.key,
    required this.category,
    required this.validateName,
    required this.onSave,
  });

  final Category category;
  final String? Function(String?) validateName;
  final ValueChanged<String> onSave;

  @override
  State<_CategoryNameEditor> createState() => _CategoryNameEditorState();
}

class _CategoryNameEditorState extends State<_CategoryNameEditor> {
  late final TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancel() {
    setState(() {
      _controller.text = widget.category.name;
      _isEditing = false;
    });
  }

  void _save() {
    final error = widget.validateName(_controller.text);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    widget.onSave(_controller.text);
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isEditing ? null : () => setState(() => _isEditing = true),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        autofocus: true,
                        maxLength: 20,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _save(),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      )
                    : Text(widget.category.name),
              ),
              if (_isEditing) ...[
                IconButton(onPressed: _cancel, icon: const Icon(Icons.close)),
                IconButton(onPressed: _save, icon: const Icon(Icons.check)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
