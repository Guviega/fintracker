import 'package:fintracker/imdb.dart';
import 'package:fintracker/model/expense.dart';
import 'package:fintracker/model/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      _valueController.text = expense.value.toStringAsFixed(2).replaceAll('.', ',');
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
      firstDate: DateTime(DateTime.now().year-100),
      lastDate: DateTime(DateTime.now().year+1),
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
      Imdb.expensesList.add(Expense(
        description: _descriptionController.text.trim(),
        date: _date,
        value: value,
        paymentMethod: _paymentMethod!,
        category: category,
      ));
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
      appBar: AppBar(elevation: 2, title: Text(isEditing ? 'Edit Expense' : 'Register Expense')),
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
          child: Column(children: [
            _card('Value', Icons.arrow_downward, TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(prefix: Text("+ R\$ ", style: TextStyle(color: color),), filled: true, border: InputBorder.none),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
              validator: (text) {
                final value = _parseValue(text);
                if (value == null || value <= 0) return 'Enter a value greater than zero';
                return null;
              },
            )),
            const SizedBox(height: 8),
            _card('Description', Icons.description, TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(filled: true, border: InputBorder.none),
              validator: (text) => (text == null || text.trim().isEmpty) ? 'Enter a description' : null,
            )),
            const SizedBox(height: 8),
            _card('Category', Icons.category, FormField<int>(
              initialValue: _selectedCategory,
              validator: (_) => _selectedCategory < 0 ? 'Select a category' : null,
              builder: (state) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: 8, children: [
                  for (var i = 0; i < categories.length; i++) ChoiceChip(
                    label: Text(categories[i].name),
                    selected: _selectedCategory == i,
                    onSelected: (_) => setState(() {
                      _selectedCategory = i;
                      state.didChange(i);
                    }),
                    selectedColor: color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  ),
                ]),
                if (state.hasError) Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(state.errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              ]),
            )),
            const SizedBox(height: 8),
            _card('Payment Method', Icons.credit_card, FormField<PaymentMethod>(
              initialValue: _paymentMethod,
              validator: (_) => _paymentMethod == null ? 'Select a payment method' : null,
              builder: (state) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: 8, children: [
                  for (final method in PaymentMethod.values) ChoiceChip(
                    label: Text(method.name),
                    selected: _paymentMethod == method,
                    onSelected: (_) => setState(() {
                      _paymentMethod = method;
                      state.didChange(method);
                    }),
                    selectedColor: color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  ),
                ]),
                if (state.hasError) Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(state.errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              ]),
            )),
            const SizedBox(height: 8),
            _card('Date', Icons.calendar_month, TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: const InputDecoration(filled: true, border: InputBorder.none, suffixIcon: Icon(Icons.date_range)),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _card(String title, IconData icon, Widget field) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        ListTile(leading: Icon(icon, color: Colors.red), title: Text(title)),
        Padding(padding: const EdgeInsets.all(8), child: field),
      ]),
    ),
  );
}
