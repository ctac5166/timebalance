import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/schemeControllerProvider.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/widgets/popupChoiceMenu.dart';

class SelectSchemeButton extends ConsumerStatefulWidget {
  const SelectSchemeButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectSchemeButtonState();
}

class _SelectSchemeButtonState extends ConsumerState<SelectSchemeButton> {
  bool schemesInited = false;

  Future loadSchemes() async {
    if (!schemesInited) {
      await ref.read(schemeControllerProvider.notifier).loadAllSchemes();
      final schemeControllerState = ref.read(schemeControllerProvider);
      ref
          .read(timerControllerProvider.notifier)
          .updateSchemes(schemeControllerState);
      setState(() {
        schemesInited = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerController = ref.watch(timerControllerProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!schemesInited) {
        await loadSchemes();
      }
    });

    return PopupChoiceMenu(
      key: ValueKey(
          "SelectSchemeButton-${timerController.getCurrentScheme().shemeName}"),
      actions: timerController.schemes
          .map((e) => (uid) async {
                if (uid != timerController.getCurrentScheme().shemeName) {
                  timerController.changeSheme(uid);
                  setState(() {});
                }
              })
          .toList(),
      labels: timerController.schemes.map((e) => e.shemeName).toList(),
      uids: timerController.schemes.map((e) => e.shemeName).toList(),
      icon: Icons.clear_all_rounded,
      initialSelectedIndex: timerController.schemes.indexWhere((element) =>
          element.shemeName == timerController.getCurrentScheme().shemeName),
    );
  }
}
