import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../viewmodel/expense_view_model.dart';
import '../viewmodel/currency_view_model.dart';

class EditExpenseView extends ConsumerStatefulWidget {
  final Expense expense;

  const EditExpenseView({
    super.key,
    required this.expense,
  });

  @override
  ConsumerState<EditExpenseView> createState() =>
      _EditExpenseViewState();
}

class _EditExpenseViewState
    extends ConsumerState<EditExpenseView> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _amountController;

  late String _category;
  late DateTime _selectedDate;

  bool _amountInitialized = false;
  bool _isSaving = false;

  static const Color darkColor = Color(0xFF393939);
  static const double usdRate = 26000;

  final List<String> categories = [
    'Sinh hoạt',
    'Đi lại',
    'Học tập',
    'Sức khỏe',
    'Giải trí',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.expense.name,
    );

    _amountController = TextEditingController();

    _category = widget.expense.category;
    _selectedDate = widget.expense.date;

    if (!categories.contains(_category)) {
      categories.add(_category);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void initializeAmount(String currency) {
    if (_amountInitialized) return;

    _amountController.text =
        widget.expense.amount.toStringAsFixed(0);

    _amountInitialized = true;
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: darkColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> saveExpense(String currency) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final inputAmount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    final updatedExpense = Expense(
      id: widget.expense.id,
      name: _nameController.text.trim(),
      category: _category,
      date: _selectedDate,
      amount: inputAmount,
    );

    try {
      await ref
          .read(expenseViewModelProvider.notifier)
          .updateExpense(updatedExpense);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật khoản chi thành công'),
          backgroundColor: Color(0xFF393939),
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể cập nhật: $error'),
        ),
      );
    }
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFD7D7D7),
          width: 1.2,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: darkColor,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyViewModelProvider);

    return currencyState.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Lỗi: $error'),
        ),
      ),

      data: (currency) {
        initializeAmount(currency);

        return Scaffold(
          backgroundColor: const Color(0xFFF9F8F6),

          appBar: AppBar(
            toolbarHeight: 64,
            backgroundColor: darkColor,
            foregroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 26,
              ),
              onPressed: () => Navigator.pop(context),
            ),

            title: const Text(
              'Chỉnh sửa khoản chi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: SafeArea(
            top: false,

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        22,
                        20,
                        20,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          buildLabel('Tên khoản chi *'),

                          TextFormField(
                            controller: _nameController,

                            decoration: inputDecoration(
                              hint: 'Nhập tên khoản chi',
                            ),

                            style: const TextStyle(
                              fontSize: 16,
                            ),

                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Vui lòng nhập tên khoản chi';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 22),

                          buildLabel('Số tiền *'),

                          TextFormField(
                            controller: _amountController,

                            keyboardType:
                            const TextInputType.numberWithOptions(
                              decimal: true,
                            ),

                            decoration: inputDecoration(
                              hint: 'Nhập số tiền',
                            ),

                            style: const TextStyle(
                              fontSize: 16,
                            ),

                            validator: (value) {
                              final amount = double.tryParse(
                                (value ?? '')
                                    .trim()
                                    .replaceAll(',', '.'),
                              );

                              if (amount == null || amount <= 0) {
                                return 'Vui lòng nhập số tiền hợp lệ';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 22),

                          buildLabel('Danh mục *'),

                          DropdownButtonFormField<String>(
                            initialValue: _category,

                            isExpanded: true,

                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: darkColor,
                              size: 28,
                            ),

                            decoration: inputDecoration(),

                            items: categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),

                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _category = value;
                                });
                              }
                            },
                          ),

                          const SizedBox(height: 22),

                          buildLabel('Ngày chi tiêu *'),

                          InkWell(
                            onTap: selectDate,

                            borderRadius: BorderRadius.circular(12),

                            child: InputDecorator(
                              decoration: inputDecoration(
                                suffixIcon: const Icon(
                                  Icons.calendar_month,
                                  color: darkColor,
                                ),
                              ),

                              child: Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate),

                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    color: const Color(0xFFF9F8F6),

                    padding: const EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      20,
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,

                            child: OutlinedButton(
                              onPressed: _isSaving
                                  ? null
                                  : () => Navigator.pop(context),

                              style: OutlinedButton.styleFrom(
                                foregroundColor: darkColor,
                                side: const BorderSide(
                                  color: darkColor,
                                  width: 1.3,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),

                              child: const Text(
                                'Hủy',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: SizedBox(
                            height: 52,

                            child: ElevatedButton(
                              onPressed: _isSaving
                                  ? null
                                  : () => saveExpense(currency),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),

                              child: _isSaving
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                'Lưu',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}