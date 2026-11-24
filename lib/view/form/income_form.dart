import 'package:fintracker/database/database_helper.dart';
import 'package:fintracker/model/income.dart';
import 'package:fintracker/view/form/widgets/income_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeForm extends StatefulWidget {
  static const routeName = 'income_form';

  const IncomeForm({super.key, this.income});

  final Income? income;

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sourceController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _date = DateTime.now();
  Income? get _income => widget.income;

  @override
  void initState() {
    super.initState();
    final income = widget.income;
    if (income != null) {
      _valueController.text = income.value
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _descriptionController.text = income.description;
      _sourceController.text = income.source;
      _date = income.date;
    }
    _dateController.text = DateFormat('dd/MM/yyyy').format(_date);
  }

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    _sourceController.dispose();
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
    final value = _parseValue(_valueController.text)!;
    final income = Income(
      id: _income?.id,
      description: _descriptionController.text.trim(),
      source: _sourceController.text.trim(),
      date: _date,
      value: value,
    );

    try {
      if (_income == null) {
        await DatabaseHelper.instance.insertIncome(income);
      } else {
        await DatabaseHelper.instance.updateIncome(income);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the income')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.green;
    final isEditing = _income != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(isEditing ? 'Edit Income' : 'Register Income'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: _save,
        tooltip: 'Save income',
        child: const Icon(Icons.check),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: IncomeFormFields(
            valueController: _valueController,
            descriptionController: _descriptionController,
            sourceController: _sourceController,
            dateController: _dateController,
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
            sourceValidator: (text) =>
                (text == null || text.trim().isEmpty) ? 'Enter a source' : null,
          ),
        ),
      ),
    );
  }
}
