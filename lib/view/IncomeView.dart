import 'package:fintracker/imdb.dart';
import 'package:fintracker/model/income.dart';
import 'package:fintracker/view/form/income_form.dart';
import 'package:flutter/material.dart';

class IncomeView extends StatefulWidget {
  static const routeName = "income_page";

  const IncomeView({super.key});


  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
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
    final incomes = Imdb.incomeList.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (incomes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text('No income yet. Add one to get started.'),
            ),
          )
        else
          for (final income in incomes) _buildIncomeCard(income),
      ],
    );
  }

  Widget _buildIncomeCard(Income income) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, IncomeForm.routeName),
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
                onPressed: () => setState(() => Imdb.incomeList.remove(income)),
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
