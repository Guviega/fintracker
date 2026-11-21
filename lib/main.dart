import 'package:fintracker/view/ExpenseView.dart';
import 'package:fintracker/view/form/income_form.dart';
import 'package:fintracker/view/IncomeView.dart';
import 'package:fintracker/model/expense.dart';
import 'package:fintracker/model/income.dart';
import 'package:flutter/material.dart';
import 'imdb.dart';

import 'view/form/expenses_form.dart';
import 'view/home_page.dart';

void main() {
  Imdb.runInitialData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTracker',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color(0xFF2563EB)),
      ),
      home: const HomePage(title: 'FinTracker'),
      routes: {
        ExpenseView.routeName: (context) => ExpenseView(),
        IncomeView.routeName: (context) => IncomeView(),
        ExpensesForm.routeName: (context) => ExpensesForm(
          expense: ModalRoute.of(context)?.settings.arguments as Expense?,
        ),
        IncomeForm.routeName: (context) => IncomeForm(
          income: ModalRoute.of(context)?.settings.arguments as Income?,
        ),
      },
    );
  }
}


