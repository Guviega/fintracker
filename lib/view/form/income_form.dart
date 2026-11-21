import 'package:fintracker/imdb.dart';
import 'package:fintracker/model/income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      _valueController.text = income.value.toStringAsFixed(2).replaceAll('.', ',');
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
    final value = _parseValue(_valueController.text)!;
    final income = _income;
    if (income == null) {
      Imdb.incomeList.add(Income(
        description: _descriptionController.text.trim(),
        source: _sourceController.text.trim(),
        date: _date,
        value: value,
      ));
    } else {
      income
        ..description = _descriptionController.text.trim()
        ..source = _sourceController.text.trim()
        ..date = _date
        ..value = value;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.green;
    final isEditing = _income != null;
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text(isEditing ? 'Edit Income' : 'Register Income')),
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
          child: Column(children: [
            _fieldCard('Value', Icons.arrow_upward, TextFormField(
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
            _fieldCard('Description', Icons.description, TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(filled: true, border: InputBorder.none),
              validator: (text) => (text == null || text.trim().isEmpty) ? 'Enter a description' : null,
            ), extra: Column(children: [
              ListTile(leading: const Icon(Icons.account_balance, color: color), title: const Text('Source')),
              Padding(padding: const EdgeInsets.all(8), child: TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(filled: true, border: InputBorder.none),
                validator: (text) => (text == null || text.trim().isEmpty) ? 'Enter a source' : null,
              )),
            ])),
            const SizedBox(height: 8),
            _fieldCard('Date', Icons.calendar_month, TextFormField(
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

  Widget _fieldCard(String title, IconData icon, Widget field, {Widget? extra}) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        ListTile(leading: Icon(icon, color: Colors.green), title: Text(title)),
        Padding(padding: const EdgeInsets.all(8), child: field),
        if (extra != null) extra,
      ]),
    ),
  );
}
