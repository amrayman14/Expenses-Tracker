import 'package:new_expenses_tracker/Widget/chart/chart.dart';
import 'package:new_expenses_tracker/Widget/expenses_list/expenses_list.dart';
import 'package:new_expenses_tracker/Widget/new_expense.dart';
import 'package:flutter/material.dart';

import '../Model/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Restaurant',
        amount: 195,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Transportation',
        amount: 26,
        date: DateTime.now(),
        category: Category.work)
  ];
  void addNewExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    int expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
          label: 'Undo',
        ),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
        context: context,
        builder: (ctx) => NewExpense(expenseAdder: addNewExpense),
        isScrollControlled: true);
  }

  @override
  Widget build(context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('There is no Expenses, add some more.'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expense: _registeredExpenses, onRemoveExpense: removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width<height? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent)
        ],
      ):
      Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent)
        ],
      ),
    );
  }
}
