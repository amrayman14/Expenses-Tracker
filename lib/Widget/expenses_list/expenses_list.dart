import 'package:new_expenses_tracker/Widget/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';
import '../../Model/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expense,
    required this.onRemoveExpense
  });

  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expense;
  @override
  Widget build(context) {
    return ListView.builder(
        itemCount: expense.length,
        itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            ),
          ),
              key: ValueKey(expense[index]),
              onDismissed: (direction){
                onRemoveExpense(expense[index]);
              },
              child: ExpensesItem(expense: expense[index]),
            ),
    );
  }
  void add(Expense newExpense) {
    expense.add(newExpense);
  }
}
