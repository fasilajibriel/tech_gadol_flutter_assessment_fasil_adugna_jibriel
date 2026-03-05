import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
    this.message = 'Loading...',
    this.compact = false,
  });

  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
