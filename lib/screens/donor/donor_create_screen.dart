import 'package:flutter/material.dart';

class DonorCreateScreen extends StatefulWidget {
  const DonorCreateScreen({super.key});

  @override
  State<DonorCreateScreen> createState() => _DonorCreateScreenState();
}

class _DonorCreateScreenState extends State<DonorCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('DonorCreateScreen')));
  }
}
