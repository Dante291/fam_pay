import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Error loading data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}