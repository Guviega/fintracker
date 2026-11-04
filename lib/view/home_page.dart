import 'package:fintracker/view/dashboard.dart';
import 'package:fintracker/view/expenses.dart';
import 'package:fintracker/view/income.dart';
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
  final fab_color = <int, Color>{
    1: Colors.teal.shade300,
    2: Colors.redAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(fontWeight: .bold),),
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
        ],
      ),

      floatingActionButton: currentPageIndex == 1 || currentPageIndex == 2
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
              backgroundColor: fab_color[currentPageIndex],
            )
          : null,
      body: Center(
        child: [Dashboard(), Income(), Expenses()][currentPageIndex],
      ),
    );
  }
}
