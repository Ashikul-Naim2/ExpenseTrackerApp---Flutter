import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_item.dart';

class HiveDataBase {
  final _myBox = Hive.box("expense_database");

  void saveData(List<ExpenseItem> allExpenses) {
    List<List<dynamic>> formatted = [];

    for (var e in allExpenses) {
      formatted.add([
        e.name,
        e.amount,
        e.dateTime.toIso8601String(),
      ]);
    }

    _myBox.put("ALL_EXPENSES", formatted);
  }

  List<ExpenseItem> readData() {
    List saved = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> expenses = [];

    for (var item in saved) {
      expenses.add(
        ExpenseItem(
          name: item[0],
          amount: item[1],
          dateTime: DateTime.parse(item[2]),
        ),
      );
    }

    return expenses;
  }
}
