import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/features/transaction/widgets/transaction_type_button.dart';
import 'package:pocketwise/features/transaction/providers/transaction_provider.dart';

class AddTransactionModalScreen extends ConsumerStatefulWidget {
  const AddTransactionModalScreen({super.key});

  @override
  ConsumerState createState() => _AddTransactionModalScreenState();
}

class _AddTransactionModalScreenState extends ConsumerState<AddTransactionModalScreen> {
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

  final List<String> _categories = ["Gıda", "Market", "Ulaşım", "Fatura", "Eğlence", "Sağlık", "Eğitim", "Giyim", "Teknoloji", "Abonelik"];

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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20, left: 20, right: 20,
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          SizedBox(height: 8.0,),
          Text("Yeni İşlem Ekle", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          TextField(
            controller: _amountController,
            onChanged: (_) => setState(() {}),
            autofocus: true,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1),
            decoration: const InputDecoration(hintText: "₺0,00", border: InputBorder.none,),
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
                  title: "Gider",
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
                  title: "Gelir",
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
                selectedColor: Colors.indigo.shade100,
                onSelected: (val) => setState(() => _selectedCategory = val ? c : null),
                label: Text(c),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "İşlem Başlığı (İsteğe bağlı)",
              filled: true,
              fillColor: Colors.grey.shade50,
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
              gradient: _isFormValid
                ? const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)])
                : LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade300]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: _isFormValid
                ? () {
                final amount = _formatter.parse(_amountController.text.trim()).toDouble();
                ref.read(transactionProvider.notifier).addTransaction(
                  _titleController.text, amount, _selectedCategory!, DateTime.now(), _selectedType!
                );
                Navigator.pop(context);
              }
              : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                "İŞLEMİ KAYDET",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
              ),
            ),
          ),
        ],
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
