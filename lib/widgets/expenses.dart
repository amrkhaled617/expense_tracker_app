import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';
import 'expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course', 
      amount: 19.99, date: DateTime.now(), 
      category: Category.work),
    Expense(
      title: 'Cinema', 
      amount: 15.69, date: DateTime.now(), 
      category: Category.leisure)]; 
 
  _openAddExpenseOverlay(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      }
    );
  }
  void _addExpense(Expense expense){
    setState(() {
        _registeredExpenses.add(expense);
    });
  }
  void removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (){
            setState(() {
              _registeredExpenses.insert(expenseIndex,expense);
            });
          },
        ),
      )
    );
  }
 
  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center (
      child: Text('No Expenses found . Start adding some!'),
    );
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
        expenses: _registeredExpenses, 
        onRemoveExpense: removeExpense
      );
    }
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          const Text('The Chart'),
          Expanded(
            child: mainContent,
            ),
        ],
      ),
    );
  }
}