import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    this.message = 'No data available.',
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
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
              Icons.inbox_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
