import 'package:fintracker/imdb.dart';
import 'package:fintracker/model/expense.dart';
import 'package:fintracker/view/form/expenses_form.dart';
import 'package:flutter/material.dart';

class ExpenseView extends StatefulWidget {
  static const routeName = "expenses_page";

  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
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
    final expenses = Imdb.expensesList.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (expenses.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text('No expenses yet. Add one to get started.'),
            ),
          )
        else
          for (final expense in expenses) _buildExpenseCard(expense),
      ],
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, ExpensesForm.routeName),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: const Icon(
                Icons.monetization_on_outlined,
                color: Colors.red,
              ),
              title: Text(expense.description),
              subtitle: Text(
                '${expense.category.name} · ${_formatPaymentMethod(expense.paymentMethod.name)}',
              ),
              trailing: IconButton(
                tooltip: 'Delete expense',
                onPressed: () =>
                    setState(() => Imdb.expensesList.remove(expense)),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Text(_formatDate(expense.date)),
                  const SizedBox(width: 16),
                  Text(
                    '- ${_formatValue(expense.value)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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

  String _formatPaymentMethod(String method) {
    return method
        .toLowerCase()
        .split('_')
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
