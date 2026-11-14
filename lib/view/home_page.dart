import 'package:fintracker/view/CategoryView.dart';
import 'package:fintracker/view/dashboard.dart';
import 'package:fintracker/view/ExpenseView.dart';
import 'package:fintracker/view/form/expenses_form.dart';
import 'package:fintracker/view/form/income_form.dart';
import 'package:fintracker/view/IncomeView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = "initialRoute";

  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  final fab_color = <int, Color>{1: Colors.green, 2: Colors.redAccent};
  final fab_route = <int, String>{
    1: IncomeForm.routeName,
    2: ExpensesForm.routeName,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(widget.title),
        leading: Icon(Icons.calendar_month),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_upward_rounded),
            label: "Income",
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_downward_rounded),
            label: "Expenses",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.category),
            icon: Icon(Icons.category_outlined),
            label: "Categories",
          ),
        ],
      ),

      floatingActionButton: currentPageIndex == 1 || currentPageIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, fab_route[currentPageIndex]!);
              },
              child: const Icon(Icons.add),
              backgroundColor: fab_color[currentPageIndex],
            )
          : null,
      body: [
        Dashboard(
          onIncomeTap: () {
            setState(() {
              currentPageIndex = 1;
            });
          },
          onExpensesTap: () {
            setState(() {
              currentPageIndex = 2;
            });
          },
        ),
        IncomeView(),
        ExpenseView(),
        CategoryView(),
      ][currentPageIndex],
    );
  }
}
