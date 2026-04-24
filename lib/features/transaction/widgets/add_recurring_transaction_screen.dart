import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/recurring_transaction_model.dart';
import 'package:pocketwise/core/utils/currency_input_formatter.dart';
import 'package:pocketwise/features/transaction/providers/recurring_transaction_provider.dart';
import 'package:pocketwise/features/transaction/widgets/date_picker_field.dart';
import 'package:pocketwise/features/transaction/widgets/transaction_type_button.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/transaction_model.dart';

class AddRecurringTransactionScreen extends ConsumerStatefulWidget {
  final RecurringTransactionModel? recurringTransactionModel;
  const AddRecurringTransactionScreen({super.key, this.recurringTransactionModel});

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
    if (widget.recurringTransactionModel != null) {
      _titleController.text = widget.recurringTransactionModel!.title;
      _amountController.text = _formatter.format(widget.recurringTransactionModel!.amount);
      _selectedCategory = widget.recurringTransactionModel!.category;
      _startDate = widget.recurringTransactionModel!.startDate;
      _endDate = widget.recurringTransactionModel!.endDate;
      _selectedFrequency = widget.recurringTransactionModel!.frequency;
      _selectedType = widget.recurringTransactionModel!.type;
    }
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
            Text(
              widget.recurringTransactionModel != null
              ? AppStrings.updateRecurringTransaction.tr()
              : AppStrings.addNewRecurringTransaction.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold
            )),
            TextField(
              controller: _amountController,
              onChanged: (_) => setState(() {}),
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
                CurrencyInputFormatter(_formatter),
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
              children: categories.map((c) {
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
            DatePickerField(
              label: AppStrings.startDate.tr(),
              selectedDate: _startDate,
              firstDate: DateTime.now(),
              hintText: AppStrings.pickStartDate.tr(),
              onDateSelected: (picked) => setState(() => _startDate = picked),
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
            DatePickerField(
              label: AppStrings.endDateOptional.tr(),
              selectedDate: _endDate,
              firstDate: _startDate ?? DateTime.now(),
              hintText: AppStrings.pickEndDate.tr(),
              onDateSelected: (picked) => setState(() => _endDate = picked),
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
                onPressed: widget.recurringTransactionModel != null && _isFormValid
                  ? () {
                  final amount = _formatter.parse(_amountController.text.trim()).toDouble();
                  ref.read(recurringTransactionProvider.notifier).updateRecurring(
                    widget.recurringTransactionModel!.id,
                    _titleController.text,
                    amount,
                    _selectedCategory!,
                    _startDate!,
                    _selectedFrequency!,
                    _selectedType!,
                    endDate: _endDate
                  );
                  Navigator.pop(context);
                } :
                _isFormValid
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
