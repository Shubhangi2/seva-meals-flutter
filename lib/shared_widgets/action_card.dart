import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String assetPath;
  final String title;
  final String content;
  final Color innerContainerColor;
  final Color? cardColor;
  final Color textColor;
  final Icon icon;
  final Function() onTap;

  const ActionCard({
    super.key,
    required this.assetPath,
    required this.onTap,
    required this.title,
    required this.content,
    required this.innerContainerColor,
    required this.textColor,
    this.cardColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        // onTap: isClickable == true ? () => onTap() : null,
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(color: cardColor ?? innerContainerColor, borderRadius: BorderRadius.circular(12)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 8),
                  icon,
                  const SizedBox(height: 32),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: innerContainerColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                        ),

                        // SizedBox(height: 2),
                        if (content.isNotEmpty)
                          Text(
                            content,
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
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
