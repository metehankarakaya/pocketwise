import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../providers/security_provider.dart';

enum PinStage { setup, confirm, verify }
enum PinMode { setup, disable, change, verify }

class PinScreen extends ConsumerStatefulWidget {
  final PinMode mode;
  const PinScreen({super.key, this.mode = PinMode.setup});

  @override
  ConsumerState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinScreen> with SingleTickerProviderStateMixin {

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => enteredPin = "");
      }
    });
    switch (widget.mode) {
      case PinMode.setup:
        currentStage = PinStage.setup;
        break;
      case PinMode.verify:
        currentStage = PinStage.verify;
        break;
      case PinMode.disable:
      case PinMode.change:
        currentStage = PinStage.verify;
        break;
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
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
          _shakeController.forward(from: 0);
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
          } else if (widget.mode == PinMode.verify) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen())
            );
          }
        } else {
          _shakeController.forward(from: 0);
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
        if (widget.mode == PinMode.disable) return AppStrings.pinDisableHeading.tr();
        if (widget.mode == PinMode.change) return AppStrings.pinChangeHeading.tr();
        return AppStrings.pinVerifyHeading.tr();
    }
  }

  String get _subtitle {
    switch (currentStage) {
      case PinStage.setup: return AppStrings.pinSetupSubtitle.tr();
      case PinStage.confirm: return AppStrings.pinConfirmSubtitle.tr();
      case PinStage.verify:
        if (widget.mode == PinMode.disable) return AppStrings.pinDisableSubtitle.tr();
        if (widget.mode == PinMode.change) return AppStrings.pinChangeSubtitle.tr();
        return AppStrings.pinVerifySubtitle.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: widget.mode == PinMode.verify ? null : Text(_appBarTitle),
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
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: Row(
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
