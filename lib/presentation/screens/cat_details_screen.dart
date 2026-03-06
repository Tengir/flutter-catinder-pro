import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/data/services/cat_api_service.dart';
import 'package:hw_1/domain/entities/cat_profile.dart';
import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/widgets/characteristic_chip.dart';

class CatDetailsScreen extends StatelessWidget {
  const CatDetailsScreen({super.key, required this.cat});

  final CatProfile cat;

  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;
    final headers = context.read<CatApiService>().imageHeaders;
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: cat.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: cat.imageUrl,
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                  httpHeaders: headers,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              breed.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${breed.origin} • ${breed.lifeSpan} ${AppStrings.detailLifeYears}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Text(
              breed.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CharacteristicChip(
                  label: AppStrings.detailTemperament,
                  value: breed.temperament,
                ),
                if (breed.energyLevel != null)
                  CharacteristicChip(
                    label: AppStrings.detailEnergy,
                    value: '${breed.energyLevel}/5',
                  ),
                if (breed.affectionLevel != null)
                  CharacteristicChip(
                    label: AppStrings.detailAffection,
                    value: '${breed.affectionLevel}/5',
                  ),
                if (breed.intelligence != null)
                  CharacteristicChip(
                    label: AppStrings.detailIntelligence,
                    value: '${breed.intelligence}/5',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
