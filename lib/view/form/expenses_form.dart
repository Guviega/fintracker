import 'package:fintracker/imdb.dart';
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
      _selectedCategory = Imdb.categoryList.toList().indexOf(expense.category);
    }
    _dateController.text = DateFormat('dd/MM/yyyy').format(_date);
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final expense = _expense;
    final category = Imdb.categoryList.elementAt(_selectedCategory);
    final value = _parseValue(_valueController.text)!;
    if (expense == null) {
      Imdb.expensesList.add(
        Expense(
          description: _descriptionController.text.trim(),
          date: _date,
          value: value,
          paymentMethod: _paymentMethod!,
          category: category,
        ),
      );
    } else {
      expense
        ..description = _descriptionController.text.trim()
        ..date = _date
        ..value = value
        ..paymentMethod = _paymentMethod!
        ..category = category;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.red;
    final isEditing = _expense != null;
    final categories = Imdb.categoryList.toList();

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
            categories: categories,
            selectedCategory: _selectedCategory,
            categoryValidator: (_) =>
                _selectedCategory < 0 ? 'Select a category' : null,
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
