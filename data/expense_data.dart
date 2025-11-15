import 'package:flutter/material.dart';
import '../date_time/date_time_helper.dart';
import '../models/expense_item.dart';
import 'hive_database.dart';

class ExpenseData extends ChangeNotifier {
  List<ExpenseItem> overallExpenseList = [];

  List<ExpenseItem> getAllExpenseList() => overallExpenseList;

  final db = HiveDataBase();

  void prepareData() {
    overallExpenseList = db.readData();
  }

  void addNewExpense(ExpenseItem expense) {
    overallExpenseList.add(expense);
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  String getDayName(DateTime date) {
    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];
  }

  DateTime startOfWeekDate() {
    DateTime today = DateTime.now();
    while (getDayName(today) != "Sun") {
      today = today.subtract(const Duration(days: 1));
    }
    return today;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> summary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      summary[date] = (summary[date] ?? 0) + amount;
    }

    return summary;
  }
}
