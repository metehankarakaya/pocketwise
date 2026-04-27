import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/core/utils/currency_input_formatter.dart';
import 'package:pocketwise/core/widgets/gradient_button.dart';
import 'package:pocketwise/core/widgets/category_selector.dart';
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
    final amount = _formatter.tryParse(_amountController.text.trim());
    return _selectedType != null &&
      _selectedCategory != null &&
      amount != null &&
      amount > 0;
  }

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
      padding: EdgeInsets.only(left: 8.0, right: 8.0,),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
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
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) => setState(() => _selectedCategory = category)
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              maxLength: 50,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                counterText: "",
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
            GradientButton(
              isValid: _isFormValid,
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
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.transactionAddedWithName.tr(
                      namedArgs: {
                        "title": _titleController.text.isNotEmpty ? _titleController.text : _selectedCategory!.tr()
                      }
                    ), style: TextStyle(color: colorScheme.onPrimaryContainer),),
                    backgroundColor: colorScheme.primaryContainer,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  )
                );
              } : null,
            ),
            const SizedBox(height: 12.0,)
          ],
        ),
      ),
    );
  }
}
