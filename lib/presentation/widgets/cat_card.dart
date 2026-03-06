import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/data/services/cat_api_service.dart';
import 'package:hw_1/domain/entities/cat_profile.dart';
import 'package:hw_1/domain/utils/app_strings.dart';

class CatCard extends StatelessWidget {
  const CatCard({super.key, required this.cat, required this.onTap});

  final CatProfile cat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final headers = context.read<CatApiService>().imageHeaders;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Hero(
              tag: cat.id,
              child: CachedNetworkImage(
                imageUrl: cat.imageUrl,
                height: 320,
                width: double.infinity,
                fit: BoxFit.cover,
                httpHeaders: headers,
                placeholder: (context, _) => Container(
                  height: 320,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 320,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.breed.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cat.breed.origin} • ${cat.breed.lifeSpan} ${AppStrings.detailLifeYears}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat.breed.temperament,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
