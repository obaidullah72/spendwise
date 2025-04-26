import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../services/database.dart';
import 'expense_form.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final dbService = DatabaseHelper.instance;
    final theme = Theme.of(context);

    return FutureBuilder<List<Category>>(
      future: dbService.getCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final categories = snapshot.data!;

        return expenseProvider.expenses.isEmpty
            ? Center(
          child: Text(
            'No expenses yet. Add one!',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: expenseProvider.expenses.length,
          itemBuilder: (context, index) {
            final expense = expenseProvider.expenses[index];
            final category = categories.firstWhere(
                  (cat) => cat.id == expense.categoryId,
            );

            return Dismissible(
              key: Key(expense.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                expenseProvider.deleteExpense(expense.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${expense.title} deleted')),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.category,
                      color: theme.primaryColor,
                    ),
                  ),
                  title: Text(
                    expense.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    '${category.name} - \$${expense.amount.toStringAsFixed(2)}\n${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: theme.primaryColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExpenseForm(expense: expense),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExpenseForm(expense: expense),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
