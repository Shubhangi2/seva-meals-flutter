import 'package:flutter/material.dart';

class NotificatoinScreen extends StatefulWidget {
  final String role;
  const NotificatoinScreen({super.key, required this.role});

  @override
  State<NotificatoinScreen> createState() => _NotificatoinScreenState();
}

class _NotificatoinScreenState extends State<NotificatoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('NotificatoinScreen')));
  }
}
