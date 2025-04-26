import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/expense_provider.dart';
import '../services/database.dart';

class StatsScreen extends StatelessWidget {
  StatsScreen({Key? key}) : super(key: key);

  final Future<List<Category>> _categoriesFuture = DatabaseHelper.instance.getCategories(); // ✅ Cached Future

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF121212), Color(0xFF1E1E1E)]
                : [theme.scaffoldBackgroundColor, theme.colorScheme.secondary.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: theme.colorScheme.surface.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder<List<Category>>(
                      future: _categoriesFuture, // ✅ Using cached future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No data available.'));
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

                        return PieChart(
                          PieChartData(
                            sections: categoryTotals.entries.map((entry) {
                              final category = categories.firstWhere(
                                    (cat) => cat.id == entry.key,
                                orElse: () => Category(id: 0, name: 'Unknown', icon: ''),
                              );
                              return PieChartSectionData(
                                value: entry.value,
                                title: '${category.name}\n\$${entry.value.toStringAsFixed(2)}',
                                color: Colors.primaries[entry.key % Colors.primaries.length],
                                radius: 90,
                                titleStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement export functionality
                  },
                  icon: Icon(Icons.download_rounded),
                  label: Text('Export Report', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
