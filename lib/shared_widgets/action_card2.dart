import 'package:flutter/material.dart';

class ActionCard2 extends StatelessWidget {
  final String assetPath;
  final String title;
  final String content;
  final Color color;
  final Color textColor;
  final Function() onTap;

  const ActionCard2({
    super.key,
    required this.assetPath,
    required this.onTap,
    required this.title,
    required this.content,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        // onTap: isClickable == true ? () => onTap() : null,
        onTap: () => onTap(),
        child: Container(
          height: 108,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
            child: Column(
              children: [
                SizedBox(height: 50, width: 50, child: Image.asset(assetPath)),
                const SizedBox(height: 2),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: TextStyle(color: textColor)),

                      // SizedBox(height: 2),
                      if (content.isNotEmpty) Text(content, style: TextStyle(color: textColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
