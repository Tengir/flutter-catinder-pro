import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/domain/entities/cat_profile.dart';
import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/controllers/tinder_controller.dart';
import 'package:hw_1/presentation/screens/cat_details_screen.dart';
import 'package:hw_1/presentation/widgets/app_error_dialog.dart';
import 'package:hw_1/presentation/widgets/cat_card.dart';

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key});

  @override
  State<TinderScreen> createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      context.read<TinderController>().init();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TinderController>(
      builder: (context, controller, _) {
        _listenError(controller);
        final cat = controller.currentCat;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _LikesBadge(count: controller.likesCount),
              const SizedBox(height: 16),
              Expanded(
                child: _CatArea(
                  cat: cat,
                  isLoading: controller.isLoading,
                  onTap: (profile) => _openDetails(context, profile),
                  onLike: () => controller.likeCat(),
                  onDislike: () => controller.dislikeCat(),
                ),
              ),
              const SizedBox(height: 12),
              _SwipeButtons(
                onDislike: () => controller.dislikeCat(),
                onLike: () => controller.likeCat(),
                isBusy: controller.isLoading,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => controller.loadNextCat(forceError: true),
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text(AppStrings.tinderTestError),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _listenError(TinderController controller) {
    final error = controller.consumeError();
    if (error == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showAppErrorDialog(
        context,
        error,
        onRetry: () => controller.loadNextCat(),
      );
    });
  }

  void _openDetails(BuildContext context, CatProfile cat) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CatDetailsScreen(cat: cat)));
  }
}

class _CatArea extends StatelessWidget {
  const _CatArea({
    required this.cat,
    required this.isLoading,
    required this.onTap,
    required this.onLike,
    required this.onDislike,
  });

  final CatProfile? cat;
  final bool isLoading;
  final ValueChanged<CatProfile> onTap;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    final current = cat;
    if (current == null && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (current == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppStrings.tinderNoCat),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onDislike,
            child: const Text(AppStrings.tinderTryAgain),
          ),
        ],
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Dismissible(
        key: ValueKey(current.id),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onLike();
          } else {
            onDislike();
          }
          return false;
        },
        child: CatCard(cat: current, onTap: () => onTap(current)),
      ),
    );
  }
}

class _LikesBadge extends StatelessWidget {
  const _LikesBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, color: Colors.pinkAccent),
          const SizedBox(width: 8),
          Text(
            '${AppStrings.tinderLikesCount}$count',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _SwipeButtons extends StatelessWidget {
  const _SwipeButtons({
    required this.onDislike,
    required this.onLike,
    required this.isBusy,
  });

  final VoidCallback onDislike;
  final VoidCallback onLike;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isBusy ? null : onDislike,
            icon: const Icon(Icons.close),
            label: const Text(AppStrings.tinderDislike),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: isBusy ? null : onLike,
            icon: const Icon(Icons.favorite),
            label: const Text(AppStrings.tinderLike),
          ),
        ),
      ],
    );
  }
}
