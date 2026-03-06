import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hw_1/domain/entities/app_error.dart';
import 'package:hw_1/domain/utils/app_strings.dart';

Future<void> showAppErrorDialog(
  BuildContext context,
  AppError error, {
  VoidCallback? onRetry,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(AppStrings.errorDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error.message),
            if (kDebugMode && error.debugMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                error.debugMessage!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.redAccent),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.errorDialogClose),
          ),
          if (onRetry != null)
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text(AppStrings.errorDialogRetry),
            ),
        ],
      );
    },
  );
}
