import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/screens/shared_widgets/donation_card.dart';
import 'package:seva_meal/screens/shared_widgets/searchbar.dart';

class DonorHistoryScreen extends StatefulWidget {
  const DonorHistoryScreen({super.key});

  @override
  State<DonorHistoryScreen> createState() => _DonorHistoryScreenState();
}

class _DonorHistoryScreenState extends State<DonorHistoryScreen> {
  List<String> items = ["one", "twp", "three", "four", "five"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Your Donations",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 12),
              CustomSearchBar(items: items, displayText: (item) => item, onSelected: (value) {}),
              SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => DonationCard(),
                  itemCount: 5,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
