import 'package:fintracker/view/CategoryView.dart';
import 'package:fintracker/view/dashboard.dart';
import 'package:fintracker/view/ExpenseView.dart';
import 'package:fintracker/view/form/expenses_form.dart';
import 'package:fintracker/view/form/income_form.dart';
import 'package:fintracker/view/IncomeView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = "initialRoute";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> navigationTitles = ["Dashboard", "Income", "Expenses", "Categories"];
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
        title: Text(navigationTitles[currentPageIndex]),
        leading: Image.asset("assets/icon/fintracker_icon_foreground.png")
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
            label: navigationTitles[0],
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_upward_rounded),
            label: navigationTitles[1],
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_downward_rounded),
            label: navigationTitles[2],
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.category),
            icon: Icon(Icons.category_outlined),
            label: navigationTitles[3],
          ),
        ],
      ),

      floatingActionButton: currentPageIndex == 1 || currentPageIndex == 2
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, fab_route[currentPageIndex]!);
                if (mounted) setState(() {});
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
