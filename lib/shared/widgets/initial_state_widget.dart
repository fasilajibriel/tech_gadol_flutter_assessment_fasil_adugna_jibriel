import 'package:flutter/material.dart';

class InitialStateWidget extends StatelessWidget {
  const InitialStateWidget({
    super.key,
    this.message = 'Preparing data...',
    this.compact = false,
  });

  final String message;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
