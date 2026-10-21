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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
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
              label: "Expense",
            ),
          ],
      ),
      body: Center(
        child: Text(
          ["Dashboard", "Income", "Expense"][currentPageIndex],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
