import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_list.dart';
import '../widgets/expense_form.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SpendWise', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add, size: 28),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ExpenseForm(),
          //       ),
          //     );
          //   },
          //   tooltip: 'Add Expense',
          // ),
          IconButton(
            icon: Icon(Icons.pie_chart, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/stats'),
            tooltip: 'View Statistics',
          ),
          IconButton(
            icon: Icon(Icons.settings, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, child) {
            provider.fetchExpenses();
            return ExpenseList();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExpenseForm()),
          );
        },
        backgroundColor: theme.primaryColor,
        child: Icon(Icons.add),
        tooltip: 'Add Expense',
      ),
    );
  }
}