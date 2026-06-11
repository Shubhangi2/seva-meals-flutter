import 'package:flutter/material.dart';

class DonorAccountScreen extends StatefulWidget {
  const DonorAccountScreen({super.key});

  @override
  State<DonorAccountScreen> createState() => _DonorAccountScreenState();
}

class _DonorAccountScreenState extends State<DonorAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('DonorAccountScreen')));
  }
}
