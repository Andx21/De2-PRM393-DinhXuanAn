import '../models/expense.dart';
import '../database//database_helper.dart';

class ExpenseRepository {
  final DatabaseHelper databaseHelper;

  ExpenseRepository(this.databaseHelper);

  Future<List<Expense>> getExpenses() async {
    final data = await databaseHelper.getExpenses();

    return data.map((item) {
      return Expense.fromMap(item);
    }).toList();
  }

  Future<void> updateExpense(Expense expense) async {
    final result = await databaseHelper.updateExpense(
      expense.toMap(),
    );

    if (result == 0) {
      throw Exception('Không tìm thấy khoản chi cần cập nhật');
    }
  }
}