import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final double progress;

  const ProgressBarWidget({super.key, this.progress = 0.5});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tu progreso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).colorScheme.surface,
            color: Colors.blue,
            minHeight: 10,
          ),
        ],
      ),
    );
  }
}
