import 'package:flutter/material.dart';

class HalfPane extends StatelessWidget {
  const HalfPane({
    super.key,
    required this.centerLabel,
    required this.name,
  });

  final String centerLabel;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox.expand(),
        Align(
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(top: 56),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [Shadow(blurRadius: 8, offset: Offset(0, 1))],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: IgnorePointer(
            child: Text(
              centerLabel,
              style: const TextStyle(
                fontSize: 64,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 8, offset: Offset(0, 1))],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
