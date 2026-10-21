import 'package:fintracker/view/expenses.dart';
import 'package:fintracker/view/form/income_form.dart';
import 'package:fintracker/view/income.dart';
import 'package:flutter/material.dart';

import 'view/form/expenses_form.dart';
import 'view/home_page.dart';

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


