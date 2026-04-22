import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/features/dashboard/providers/dashboard_provider.dart';

class TotalBalance extends ConsumerWidget {
  final double balance;
  const TotalBalance({super.key, required this.balance});

  static final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final formattedAmount = formatter.format(balance);

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          dashboard
          ? "₺******"
          : formattedAmount, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20,),
        IconButton(
          onPressed: () => ref.read(dashboardProvider.notifier).toggleVisibility(),
          icon: Icon(Icons.remove_red_eye),
        )
      ],
    );
  }
}
