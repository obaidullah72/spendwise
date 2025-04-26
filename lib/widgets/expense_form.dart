import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../services/database.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? expense;

  ExpenseForm({this.expense});

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late DateTime _date;
  late int _categoryId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _title = widget.expense?.title ?? '';
    _amount = widget.expense?.amount ?? 0.0;
    _date = widget.expense?.date ?? DateTime.now();
    _categoryId = widget.expense?.categoryId ?? 1;

    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseHelper.instance;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? 'Add Expense' : 'Edit Expense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FutureBuilder<List<Category>>(
            future: dbService.getCategories(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data!;

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.0),
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
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTextFormField(
                              initialValue: _title,
                              label: 'Title',
                              icon: Icons.description,
                              onSaved: (value) => _title = value!,
                              validator: (value) =>
                              value!.isEmpty ? 'Enter a title' : null,
                            ),
                            SizedBox(height: 20),
                            _buildTextFormField(
                              initialValue: _amount.toString(),
                              label: 'Amount',
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              onSaved: (value) =>
                              _amount = double.parse(value!),
                              validator: (value) =>
                              value!.isEmpty ? 'Enter an amount' : null,
                            ),
                            SizedBox(height: 20),
                            _buildDropdownField(categories, theme),
                            SizedBox(height: 20),
                            _buildDatePicker(theme),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final expense = Expense(
                                    id: widget.expense?.id,
                                    title: _title,
                                    amount: _amount,
                                    date: _date,
                                    categoryId: _categoryId,
                                  );
                                  final provider = Provider.of<ExpenseProvider>(
                                    context,
                                    listen: false,
                                  );
                                  if (widget.expense == null) {
                                    await provider.addExpense(expense);
                                  } else {
                                    await provider.updateExpense(expense);
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                backgroundColor: theme.primaryColor,
                              ),
                              child: Text(
                                widget.expense == null
                                    ? 'Add Expense'
                                    : 'Update Expense',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String initialValue,
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.blue.shade700),
      ),
      style: TextStyle(color: Colors.blue.shade900),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDropdownField(List<Category> categories, ThemeData theme) {
    return DropdownButtonFormField<int>(
      value: _categoryId,
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category.id,
          child: Text(category.name,
              style: TextStyle(color: Colors.blue.shade900)),
        );
      }).toList(),
      onChanged: (value) => setState(() => _categoryId = value!),
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.blue.shade700),
      ),
      dropdownColor: Colors.white,
      style: TextStyle(color: Colors.blue.shade900),
    );
  }

  Widget _buildDatePicker(ThemeData theme) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() => _date = pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.blue.shade700),
        ),
        child: Text(
          '${_date.day}/${_date.month}/${_date.year}',
          style: TextStyle(color: Colors.blue.shade900),
        ),
      ),
    );
  }
}