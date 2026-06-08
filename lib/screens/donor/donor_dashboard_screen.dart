import 'package:flutter/material.dart';

class DonorDashboardScreen extends StatefulWidget {
  const DonorDashboardScreen({super.key});

  @override
  State<DonorDashboardScreen> createState() => DonorDashboardScreenState();
}

class DonorDashboardScreenState extends State<DonorDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [const Center(child: Text('DashboardScreen'))]),
    );
  }
}
