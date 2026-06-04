import 'package:flutter/material.dart';

class ActionBlock extends StatelessWidget {
  final String title;
  final Icon icon;
  final Color btnColor;
  final Function onTapCallback;
  const ActionBlock({
    super.key,
    required this.title,
    required this.icon,
    required this.onTapCallback,
    required this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCallback(),

      child: Container(
        decoration: BoxDecoration(color: btnColor, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                spacing: 8,
                children: [
                  icon,
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
