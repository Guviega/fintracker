import 'package:fintracker/database/database_helper.dart';
import 'package:fintracker/model/income.dart';
import 'package:fintracker/view/form/income_form.dart';
import 'package:flutter/material.dart';

class IncomeView extends StatefulWidget {
  static const routeName = 'income_page';

  const IncomeView({super.key});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  List<Income> _incomes = [];
  bool _isLoading = true;
  bool _hasLoadError = false;

  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  Future<void> _loadIncomes() async {
    try {
      final incomes = await DatabaseHelper.instance.getIncomes();
      if (!mounted) return;
      setState(() {
        _incomes = incomes;
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

  Future<void> _deleteIncome(Income income) async {
    final id = income.id;
    if (id == null) return;

    try {
      await DatabaseHelper.instance.deleteIncome(id);
      await _loadIncomes();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete the income')),
      );
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatValue(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'R\$ $whole,${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_hasLoadError) {
      return Center(
        child: TextButton(
          onPressed: _loadIncomes,
          child: const Text('Could not load income. Retry.'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_incomes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text('No income yet. Add one to get started.'),
            ),
          )
        else
          for (final income in _incomes) _buildIncomeCard(income),
      ],
    );
  }

  Widget _buildIncomeCard(Income income) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.pushNamed(
            context,
            IncomeForm.routeName,
            arguments: income,
          );
          if (mounted) await _loadIncomes();
        },
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: const Icon(
                Icons.monetization_on_outlined,
                color: Colors.green,
              ),
              title: Text(income.description),
              subtitle: Text(income.source),
              trailing: IconButton(
                tooltip: 'Delete income',
                onPressed: () => _deleteIncome(income),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Text(_formatDate(income.date)),
                  const SizedBox(width: 16),
                  Text(
                    '+ ${_formatValue(income.value)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
