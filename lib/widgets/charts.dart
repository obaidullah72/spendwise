import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/expense_provider.dart';
import '../services/database.dart';

class ExpenseCharts extends StatelessWidget {
  ExpenseCharts({Key? key}) : super(key: key);

  final Future<List<Category>> _categoriesFuture = DatabaseHelper.instance.getCategories();

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF0D0D0D), const Color(0xFF1C1C1C)]
              : [Colors.white, Colors.grey[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          final categories = snapshot.data!;
          Map<int, double> categoryTotals = {};
          for (var expense in expenseProvider.expenses) {
            categoryTotals.update(
              expense.categoryId,
                  (value) => value + expense.amount,
              ifAbsent: () => expense.amount,
            );
          }

          if (categoryTotals.isEmpty) {
            return const Center(child: Text('No expenses recorded yet.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Expense Breakdown',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: categoryTotals.entries.map((entry) {
                      final category = categories.firstWhere(
                            (cat) => cat.id == entry.key,
                        orElse: () => Category(id: 0, name: 'Unknown', icon: ''),
                      );
                      return PieChartSectionData(
                        value: entry.value,
                        title: '${category.name}\n\$${entry.value.toStringAsFixed(1)}',
                        color: Colors.primaries[entry.key % Colors.primaries.length].withOpacity(0.9),
                        radius: 80,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        titlePositionPercentageOffset: 0.6,
                      );
                    }).toList(),
                    sectionsSpace: 4,
                    centerSpaceRadius: 50,
                    borderData: FlBorderData(show: false),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 800),
                  swapAnimationCurve: Curves.easeOutCubic,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: categoryTotals.entries.map((entry) {
                  final category = categories.firstWhere(
                        (cat) => cat.id == entry.key,
                    orElse: () => Category(id: 0, name: 'Unknown', icon: ''),
                  );
                  return Chip(
                    label: Text(
                      '${category.name}: \$${entry.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    backgroundColor: Colors.primaries[entry.key % Colors.primaries.length].withOpacity(0.2),
                    shape: const StadiumBorder(),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
