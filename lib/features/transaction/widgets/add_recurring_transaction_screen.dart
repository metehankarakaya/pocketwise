import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/recurring_transaction_model.dart';
import 'package:pocketwise/features/transaction/providers/recurring_transaction_provider.dart';
import 'package:pocketwise/features/transaction/widgets/transaction_type_button.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/transaction_model.dart';

class AddRecurringTransactionScreen extends ConsumerStatefulWidget {
  const AddRecurringTransactionScreen({super.key});

  @override
  ConsumerState createState() => _AddRecurringTransactionScreenState();
}

class _AddRecurringTransactionScreenState extends ConsumerState<AddRecurringTransactionScreen> {

  static final _formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

  TransactionType? _selectedType;
  String? _selectedCategory;
  RecurringFrequency? _selectedFrequency;
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  DateTime? _startDate;
  DateTime? _endDate;

  bool get _isFormValid {
    return _selectedType != null &&
      _selectedCategory != null &&
      _selectedFrequency != null &&
      _amountController.text.isNotEmpty &&
      _amountController.text != "₺0,00" &&
      _titleController.text.trim().isNotEmpty &&
      _startDate != null;
  }

  final List<String> _categories = [
    AppStrings.food,
    AppStrings.groceries,
    AppStrings.transport,
    AppStrings.bills,
    AppStrings.subscription,
    AppStrings.entertainment,
    AppStrings.health,
    AppStrings.clothing,
    AppStrings.technology,
    AppStrings.education,
  ];

  final List<RecurringFrequency> _frequencies = [
    RecurringFrequency.daily,
    RecurringFrequency.weekly,
    RecurringFrequency.monthly,
    RecurringFrequency.yearly,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20, left: 20, right: 20,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: .min,
          children: [
            const SizedBox(height: 16),
            Text(AppStrings.addNewTransaction.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold
            )),
            TextField(
              controller: _amountController,
              onChanged: (_) => setState(() {}),
              //autofocus: true,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: "₺0,00",
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _IntlAmountFormatter(_formatter),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TransactionTypeButton(
                    onTap: () {
                      setState(() {
                        _selectedType = TransactionType.expense;
                      });
                    },
                    isSelected: _selectedType == TransactionType.expense,
                    title: AppStrings.transactionExpense.tr(),
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: TransactionTypeButton(
                    onTap: () {
                      setState(() {
                        _selectedType = TransactionType.income;
                      });
                    },
                    isSelected: _selectedType == TransactionType.income,
                    title: AppStrings.transactionIncome.tr(),
                    color: Colors.green.shade400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: _categories.map((c) {
                return ChoiceChip(
                  showCheckmark: false,
                  selected: _selectedCategory == c,
                  selectedColor: colorScheme.primaryContainer,
                  onSelected: (val) => setState(() => _selectedCategory = val ? c : null),
                  label: Text(c.tr()),
                  labelStyle: TextStyle(
                    color: _selectedCategory == c ? colorScheme.onPrimaryContainer : colorScheme.onSurface
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.startDate.tr(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != _startDate) {
                      setState(() => _startDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 20,
                          color: colorScheme.primary
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _startDate == null
                            ? AppStrings.pickStartDate.tr()
                            : DateFormat('dd MMMM yyyy', 'tr_TR').format(_startDate!),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: _startDate == null ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: colorScheme.onSurfaceVariant
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: _frequencies.map((c) {
                return ChoiceChip(
                  showCheckmark: false,
                  selected: _selectedFrequency == c,
                  selectedColor: colorScheme.primaryContainer,
                  onSelected: (val) => setState(() => _selectedFrequency = val ? c : null),
                  label: Text(c.name.tr()),
                  labelStyle: TextStyle(
                    color: _selectedFrequency == c ? colorScheme.onPrimaryContainer : colorScheme.onSurface
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.endDateOptional.tr(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: _startDate ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != _endDate) {
                      setState(() => _endDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 20,
                          color: colorScheme.primary
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _endDate == null
                            ? AppStrings.pickEndDate.tr()
                            : DateFormat('dd MMMM yyyy', 'tr_TR').format(_endDate!),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: _endDate == null ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: colorScheme.onSurfaceVariant
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: AppStrings.transactionTitleHint.tr(),
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _isFormValid
                  ? LinearGradient(colors: [colorScheme.primary, colorScheme.secondary])
                  : null,
                color: _isFormValid ? null : colorScheme.surfaceContainerHighest
              ),
              child: ElevatedButton(
                onPressed: _isFormValid
                  ? () {
                  final amount = _formatter.parse(_amountController.text.trim()).toDouble();
                  ref.read(recurringTransactionProvider.notifier).addRecurring(
                    title: _titleController.text,
                    amount: amount,
                    category: _selectedCategory!,
                    startDate: _startDate!,
                    endDate: _endDate,
                    frequency: _selectedFrequency!,
                    type: _selectedType!,
                    isActive: true
                  );
                  Navigator.pop(context);
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: _isFormValid ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  AppStrings.saveButton.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntlAmountFormatter extends TextInputFormatter {
  final NumberFormat formatter;

  _IntlAmountFormatter(this.formatter);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.length > 9) return oldValue;

    double value = double.parse(cleanText) / 100;
    String formatted = formatter.format(value);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
