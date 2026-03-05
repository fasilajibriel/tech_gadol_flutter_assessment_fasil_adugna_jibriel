import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.compact = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Center(
        child: TextButton(
          onPressed: onRetry,
          child: Text(message, textAlign: TextAlign.center),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
            ],
          ],
        ),
      ),
    );
  }
}
