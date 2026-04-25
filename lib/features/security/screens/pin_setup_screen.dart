import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../providers/security_provider.dart';

enum PinStage { setup, confirm, verify }
enum PinMode { setup, disable, change }

class PinSetupScreen extends ConsumerStatefulWidget {
  final PinMode mode;
  const PinSetupScreen({super.key, this.mode = PinMode.setup});

  @override
  ConsumerState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {

  @override
  void initState() {
    super.initState();
    switch (widget.mode) {
      case PinMode.setup:
        currentStage = PinStage.setup;
        break;
      case PinMode.disable:
      case PinMode.change:
        currentStage = PinStage.verify;
        break;
    }
  }

  String enteredPin = "";

  void _onKeyPress(String value) async {
    if (enteredPin.length < 6) {
      setState(() => enteredPin += value);
      HapticFeedback.lightImpact();
    }

    if (enteredPin.length == 6) {
      if (currentStage == PinStage.setup) {
        setState(() {
          firstPin = enteredPin;
          enteredPin = "";
          currentStage = PinStage.confirm;
        });
      } else if (currentStage == PinStage.confirm) {
        if (enteredPin == firstPin) {
          ref.read(securityProvider.notifier).enableLock(enteredPin);
          Navigator.pop(context);
        } else {
          setState(() {
            enteredPin = "";
          });
        }
      } else if (currentStage == PinStage.verify) {
        final isValid = await ref.read(securityProvider.notifier).verifyPin(enteredPin);
        if (!mounted) return;
        if (isValid) {
          if (widget.mode == PinMode.disable) {
            ref.read(securityProvider.notifier).disableLock();
            Navigator.pop(context);
          } else if (widget.mode == PinMode.change) {
            setState(() {
              enteredPin = "";
              currentStage = PinStage.setup;
            });
          }
        } else {
          setState(() => enteredPin = "");
        }
      }
    }
  }

  void _onDelete() {
    if (enteredPin.isNotEmpty) {
      setState(() => enteredPin = enteredPin.substring(0, enteredPin.length - 1));
      HapticFeedback.mediumImpact();
    }
  }

  PinStage currentStage = PinStage.setup;
  String firstPin = "";

  String get _appBarTitle {
    switch (currentStage) {
      case PinStage.setup: return AppStrings.pinSetupTitle.tr();
      case PinStage.confirm: return AppStrings.pinConfirmTitle.tr();
      case PinStage.verify: return AppStrings.pinVerifyTitle.tr();
      }
  }

  String get _title {
    switch (currentStage) {
      case PinStage.setup: return AppStrings.pinSetupHeading.tr();
      case PinStage.confirm: return AppStrings.pinConfirmHeading.tr();
      case PinStage.verify:
        return widget.mode == PinMode.disable
          ? AppStrings.pinDisableHeading.tr()
          : AppStrings.pinChangeHeading.tr();
      }
  }

  String get _subtitle {
    switch (currentStage) {
      case PinStage.setup: return AppStrings.pinSetupSubtitle.tr();
      case PinStage.confirm: return AppStrings.pinConfirmSubtitle.tr();
      case PinStage.verify:
        return widget.mode == PinMode.disable
          ? AppStrings.pinDisableSubtitle.tr()
          : AppStrings.pinChangeSubtitle.tr();
      }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Text(
              _title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                bool isFilled = enteredPin.length > index;
                return Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? colorScheme.primary : Colors.transparent,
                    border: Border.all(
                      color: isFilled ? colorScheme.primary : colorScheme.outline,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) return const SizedBox.shrink();
                if (index == 11) {
                  return IconButton(
                    onPressed: _onDelete,
                    icon: const Icon(Icons.backspace_outlined),
                  );
                }
                String val = index == 10 ? "0" : "${index + 1}";
                return InkWell(
                  onTap: () => _onKeyPress(val),
                  borderRadius: BorderRadius.circular(50),
                  child: Center(
                    child: Text(
                      val,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
