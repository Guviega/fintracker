import 'package:fintracker/model/category.dart';
import 'package:flutter/material.dart';

class CategoryNameEditor extends StatefulWidget {
  const CategoryNameEditor({
    super.key,
    required this.category,
    required this.validateName,
    required this.onSave,
    required this.onDelete,
  });

  final Category category;
  final String? Function(String?) validateName;
  final ValueChanged<String> onSave;
  final VoidCallback onDelete;

  @override
  State<CategoryNameEditor> createState() => _CategoryNameEditorState();
}

class _CategoryNameEditorState extends State<CategoryNameEditor> {
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
              IconButton(
                tooltip: 'Delete category',
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
