import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/data/services/cat_api_service.dart';
import 'package:hw_1/domain/entities/breed.dart';
import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/controllers/breeds_controller.dart';
import 'package:hw_1/presentation/screens/breed_details_screen.dart';

class BreedListScreen extends StatefulWidget {
  const BreedListScreen({super.key});

  @override
  State<BreedListScreen> createState() => _BreedListScreenState();
}

class _BreedListScreenState extends State<BreedListScreen> {
  final _searchController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<BreedsController>().init();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BreedsController>(
      builder: (context, controller, _) {
        if (controller.error != null && !controller.hasData) {
          return _ErrorState(
            message: controller.error!.message,
            onRetry: controller.retry,
          );
        }
        if (controller.isLoading && !controller.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final breeds = controller.breeds;
        final imageHeaders = context.read<CatApiService>().imageHeaders;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: AppStrings.breedsSearchHint,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: controller.search,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.retry,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: breeds.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final breed = breeds[index];
                    return _BreedTile(
                      breed: breed,
                      onTap: () => _openDetails(context, breed),
                      imageHeaders: imageHeaders,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDetails(BuildContext context, Breed breed) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => BreedDetailsScreen(breed: breed)));
  }
}

class _BreedTile extends StatelessWidget {
  const _BreedTile({
    required this.breed,
    required this.onTap,
    required this.imageHeaders,
  });

  final Breed breed;
  final VoidCallback onTap;
  final Map<String, String>? imageHeaders;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: _PreviewImage(url: breed.previewImage, headers: imageHeaders),
      title: Text(
        breed.name,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('${breed.origin} • ${breed.temperament}'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.url, required this.headers});

  final String? url;
  final Map<String, String>? headers;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const CircleAvatar(radius: 28, child: Icon(Icons.pets));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: url!,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        httpHeaders: headers,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => onRetry(),
              child: const Text(AppStrings.breedsRetry),
            ),
          ],
        ),
      ),
    );
  }
}
