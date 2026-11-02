import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../viewmodel/expense_view_model.dart';
import '../viewmodel/currency_view_model.dart';
import 'edit_view.dart';
import 'currency_dialog.dart';

class ExpenseListView extends ConsumerWidget {
  const ExpenseListView({super.key});

  static const Color darkColor = Color(0xFF393939);
  static const Color backgroundColor = Color(0xFFF8F7F5);

  String formatAmount(double amount, String currency) {
    return '${NumberFormat('#,##0.##', 'en_US').format(amount)} $currency';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseViewModelProvider);
    final currencyState = ref.watch(currencyViewModelProvider);

    final currency = currencyState.value ?? 'VND';

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: darkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: const Text(
          'Quản lý chi tiêu',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 28,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => const CurrencyDialog(),
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: currencyState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : expenseState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stack) => Center(
          child: Text('Lỗi: $error'),
        ),

        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có khoản chi nào',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            itemCount: expenses.length,

            separatorBuilder: (_, __) {
              return Divider(
                height: 1,
                thickness: 0.8,
                color: Colors.grey.shade200,
              );
            },

            itemBuilder: (context, index) {
              final expense = expenses[index];

              return Container(
                color: Colors.white,

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Expanded(
                      flex: 5,

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          Text(
                            expense.name,

                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF303030),
                            ),

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EEEE),
                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: Text(
                              expense.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 5,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(expense.date),

                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            formatAmount(
                              expense.amount,
                              currency,
                            ),

                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF303030),
                            ),

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(
                      width: 38,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 38,
                        ),

                        icon: const Icon(
                          Icons.edit,
                          size: 24,
                          color: Color(0xFF333333),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditExpenseView(
                                expense: expense,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}