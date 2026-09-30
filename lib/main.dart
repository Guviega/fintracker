import 'package:fintracker/expenses.dart';
import 'package:fintracker/income.dart';
import 'package:fintracker/income_form.dart';
import 'package:flutter/material.dart';

import 'expenses_form.dart';
import 'home_page.dart';

void main() {
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
      home: const HomePage(title: 'FinTracker Home Page'),
      routes: {
        Expenses.routeName: (context) => Expenses(),
        Income.routeName: (context) => Income(),
        ExpensesForm.routeName: (context) => ExpensesForm(),
        IncomeForm.routeName: (context) => IncomeForm()
      },
    );
  }
}


