import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

class GoogleWidget extends StatelessWidget {
  const GoogleWidget.GoogleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/google_logo.png", height: 24, width: 24),
          const SizedBox(width: 8),
          const Text("Sign in with Google", style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }
}
