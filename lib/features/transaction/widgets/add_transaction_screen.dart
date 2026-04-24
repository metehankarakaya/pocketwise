import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/core/utils/currency_input_formatter.dart';
import 'package:pocketwise/features/transaction/widgets/transaction_type_button.dart';
import 'package:pocketwise/features/transaction/providers/transaction_provider.dart';

import '../../../core/constants/app_strings.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel? transactionModel;
  const AddTransactionScreen({super.key, this.transactionModel});

  @override
  ConsumerState createState() => _AddTransactionModalScreenState();
}

class _AddTransactionModalScreenState extends ConsumerState<AddTransactionScreen> {
  static final _formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

  TransactionType? _selectedType;
  String? _selectedCategory;
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  bool get _isFormValid {
    return _selectedType != null &&
      _selectedCategory != null &&
      _amountController.text.isNotEmpty &&
      _amountController.text != "₺0,00";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    if (widget.transactionModel != null) {
      _titleController.text = widget.transactionModel!.title;
      _amountController.text = _formatter.format(widget.transactionModel!.amount);
      _selectedCategory = widget.transactionModel!.category;
      _selectedType = widget.transactionModel!.type;
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
              widget.transactionModel != null
              ? AppStrings.updateTransaction.tr()
              : AppStrings.addNewTransaction.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold
            )),
            TextField(
              controller: _amountController,
              onChanged: (_) => setState(() {}),
              autofocus: true,
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
            TextField(
              controller: _titleController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: AppStrings.transactionTitleHintOptional.tr(),
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
                onPressed: widget.transactionModel != null && _isFormValid
                  ? () {
                  final amount = _formatter.parse(_amountController.text.trim()).toDouble();
                  ref.read(transactionProvider.notifier).updateTransaction(
                    widget.transactionModel!.id,
                    _titleController.text,
                    amount,
                    _selectedCategory!,
                    _selectedType!
                    );
                  Navigator.pop(context);
                  } :
                _isFormValid
                  ? () {
                  final amount = _formatter.parse(_amountController.text.trim()).toDouble();
                  ref.read(transactionProvider.notifier).addTransaction(
                    _titleController.text, amount, _selectedCategory!, DateTime.now(), _selectedType!
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
