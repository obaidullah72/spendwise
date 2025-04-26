import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/database.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  final DatabaseHelper _dbService = DatabaseHelper.instance;

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    _expenses = await _dbService.getExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _dbService.insertExpense(expense);
    await fetchExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await _dbService.updateExpense(expense);
    await fetchExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await _dbService.deleteExpense(id);
    await fetchExpenses();
  }
}
