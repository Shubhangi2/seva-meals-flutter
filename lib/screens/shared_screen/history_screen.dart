import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/models/post_model.dart';
import 'package:seva_meal/providers/donor_provider.dart';
import 'package:seva_meal/screens/shared_widgets/donation_card.dart';
import 'package:seva_meal/screens/shared_widgets/searchbar.dart';

class HistoryScreen extends StatefulWidget {
  final String role;
  const HistoryScreen({super.key, required this.role});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PostModel> posts = [];

  @override
  void initState() {
    super.initState();
    callAsyncTask();
  }

  Future<void> callAsyncTask() async {
    final posts = await context.read<DonorProvider>().getPosts();
    posts.fold((l) => print(l.message), (r) {
      setState(() {
        this.posts = r;
      });
    });
  }

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
              CustomSearchBar(
                items: posts,
                displayText: (item) => item.title,
                onSelected: (value) {},
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => DonationCard(postModel: posts[index]),
                  itemCount: posts.length,
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
