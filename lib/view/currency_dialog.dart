import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/currency_view_model.dart';

class CurrencyDialog extends ConsumerStatefulWidget {
  const CurrencyDialog({super.key});

  @override
  ConsumerState<CurrencyDialog> createState() =>
      _CurrencyDialogState();
}

class _CurrencyDialogState
    extends ConsumerState<CurrencyDialog> {

  String? selectedCurrency;
  bool isSaving = false;

  static const Color darkColor = Color(0xFF393939);

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyViewModelProvider);

    return currencyState.when(
      loading: () => const AlertDialog(
        content: Center(
          heightFactor: 1,
          child: CircularProgressIndicator(),
        ),
      ),

      error: (error, stack) => AlertDialog(
        content: Text('Lỗi: $error'),
      ),

      data: (currency) {
        selectedCurrency ??= currency;

        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 10,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          insetPadding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),

          titlePadding: const EdgeInsets.fromLTRB(
            28,
            25,
            24,
            8,
          ),

          contentPadding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8,
          ),

          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            22,
          ),

          title: const Text(
            'Đơn vị tiền tệ',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),

                visualDensity: const VisualDensity(
                  vertical: -2,
                ),

                activeColor: darkColor,

                title: const Text(
                  'VND (Việt Nam Đồng)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                value: 'VND',
                groupValue: selectedCurrency,

                onChanged: isSaving
                    ? null
                    : (value) {
                  setState(() {
                    selectedCurrency = value;
                  });
                },
              ),

              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),

                visualDensity: const VisualDensity(
                  vertical: -2,
                ),

                activeColor: darkColor,

                title: const Text(
                  'USD (Đô la Mỹ)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                value: 'USD',
                groupValue: selectedCurrency,

                onChanged: isSaving
                    ? null
                    : (value) {
                  setState(() {
                    selectedCurrency = value;
                  });
                },
              ),
            ],
          ),

          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: isSaving
                        ? null
                        : () {
                      Navigator.pop(context);
                    },

                    style: TextButton.styleFrom(
                      foregroundColor: darkColor,
                      minimumSize: const Size(0, 48),
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

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 48,

                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                        setState(() {
                          isSaving = true;
                        });

                        try {
                          await ref
                              .read(
                            currencyViewModelProvider.notifier,
                          )
                              .changeCurrency(
                            selectedCurrency!,
                          );

                          if (!context.mounted) return;

                          Navigator.pop(context);
                        } catch (error) {
                          if (!context.mounted) return;

                          setState(() {
                            isSaving = false;
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Không thể lưu: $error',
                              ),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkColor,
                        foregroundColor: Colors.white,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: isSaving
                          ? const SizedBox(
                        height: 19,
                        width: 19,
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
          ],
        );
      },
    );
  }
}