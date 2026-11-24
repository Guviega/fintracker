import 'package:fintracker/database/database_helper.dart';
import 'package:fintracker/model/category.dart';
import 'package:fintracker/model/expense.dart';
import 'package:fintracker/model/payment_method.dart';
import 'package:fintracker/view/form/widgets/expenses_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesForm extends StatefulWidget {
  static const routeName = 'expenses_form';

  const ExpensesForm({super.key, this.expense});

  final Expense? expense;

  @override
  State<ExpensesForm> createState() => _ExpensesFormState();
}

class _ExpensesFormState extends State<ExpensesForm> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _date = DateTime.now();
  Expense? get _expense => widget.expense;
  int _selectedCategory = -1;
  PaymentMethod? _paymentMethod;
  List<Category> _categories = [];
  bool _isLoadingCategories = true;
  bool _hasCategoryLoadError = false;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    if (expense != null) {
      _valueController.text = expense.value
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _descriptionController.text = expense.description;
      _date = expense.date;
      _paymentMethod = expense.paymentMethod;
    }
    _dateController.text = DateFormat('dd/MM/yyyy').format(_date);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await DatabaseHelper.instance.getCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
        _hasCategoryLoadError = false;
        _selectedCategory = categories.indexWhere(
          (category) => category.id == _expense?.category.id,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingCategories = false;
        _hasCategoryLoadError = true;
      });
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  double? _parseValue(String? text) {
    final input = (text ?? '').trim().replaceAll(' ', '');
    final normalized = input.contains(',')
        ? input.replaceAll('.', '').replaceAll(',', '.')
        : input;
    return double.tryParse(normalized);
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null) {
      setState(() {
        _date = selected;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selected);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory < 0 || _selectedCategory >= _categories.length) {
      return;
    }

    final category = _categories[_selectedCategory];
    final value = _parseValue(_valueController.text)!;
    final expense = Expense(
      id: _expense?.id,
      description: _descriptionController.text.trim(),
      date: _date,
      value: value,
      paymentMethod: _paymentMethod!,
      category: category,
    );

    try {
      if (_expense == null) {
        await DatabaseHelper.instance.insertExpense(expense);
      } else {
        await DatabaseHelper.instance.updateExpense(expense);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the expense')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.red;
    final isEditing = _expense != null;

    if (_isLoadingCategories) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Expense' : 'Register Expense'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasCategoryLoadError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Expense' : 'Register Expense'),
        ),
        body: Center(
          child: TextButton(
            onPressed: _loadCategories,
            child: const Text('Could not load categories. Retry.'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(isEditing ? 'Edit Expense' : 'Register Expense'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: _save,
        tooltip: 'Save expense',
        child: const Icon(Icons.check),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ExpensesFormFields(
            valueController: _valueController,
            descriptionController: _descriptionController,
            dateController: _dateController,
            categories: _categories,
            selectedCategory: _selectedCategory,
            categoryValidator: (_) =>
                _selectedCategory < 0 || _selectedCategory >= _categories.length
                ? 'Select a category'
                : null,
            onCategorySelected: (index) =>
                setState(() => _selectedCategory = index),
            paymentMethod: _paymentMethod,
            paymentMethodValidator: (_) =>
                _paymentMethod == null ? 'Select a payment method' : null,
            onPaymentMethodSelected: (method) =>
                setState(() => _paymentMethod = method),
            onSelectDate: _selectDate,
            valueValidator: (text) {
              final value = _parseValue(text);
              if (value == null || value <= 0) {
                return 'Enter a value greater than zero';
              }
              return null;
            },
            descriptionValidator: (text) =>
                (text == null || text.trim().isEmpty)
                ? 'Enter a description'
                : null,
          ),
        ),
      ),
    );
  }
}
