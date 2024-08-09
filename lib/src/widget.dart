import 'package:flutter/material.dart';
import 'controller.dart';

/// Clackety Typewriter widget
class Clackety extends StatelessWidget {
  final ClacketyController controller;
  final Widget Function(BuildContext context, String text) builder;
  final bool fastForwardOnTap;

  const Clackety({
    super.key,
    required this.controller,
    required this.builder,
    this.fastForwardOnTap = true,
  });

  factory Clackety.text(
    String value, {
    Key? key,
    String initialValue = '',
    TextStyle? style,
  }) {
    return Clackety(
      key: key,
      controller: ClacketyController(
        initialValue: initialValue,
        value: value,
      ),
      builder: (context, text) => Text(
        text,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller.onTyping,
      builder: (context, child) => fastForwardOnTap && controller.isTyping
          ? GestureDetector(
              onTap: () {
                controller.fastForwardSequence();
              },
              behavior: HitTestBehavior.deferToChild,
              child: Container(
                  color: Colors.transparent,
                  child: builder(context, controller.value)),
            )
          : builder(context, controller.value),
    );
  }
}
