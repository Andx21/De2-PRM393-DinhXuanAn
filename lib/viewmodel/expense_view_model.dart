import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/expense.dart';
import '../repositories/expense_repository.dart';
import '../database//database_helper.dart';

part 'expense_view_model.g.dart';

@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepository(DatabaseHelper.instance);
}

@riverpod
class ExpenseViewModel extends _$ExpenseViewModel {
  @override
  Future<List<Expense>> build() async {
    final repository = ref.watch(expenseRepositoryProvider);

    return repository.getExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    final previousData = state.value ?? [];

    state = const AsyncLoading();

    try {
      final repository = ref.read(expenseRepositoryProvider);

      await repository.updateExpense(expense);

      final updatedList = await repository.getExpenses();

      state = AsyncData(updatedList);
    } catch (error, stackTrace) {
      state = AsyncData(previousData);

      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}