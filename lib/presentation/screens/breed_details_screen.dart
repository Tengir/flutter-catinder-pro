import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/data/services/cat_api_service.dart';
import 'package:hw_1/domain/entities/breed.dart';
import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/widgets/characteristic_chip.dart';

class BreedDetailsScreen extends StatelessWidget {
  const BreedDetailsScreen({super.key, required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final headers = context.read<CatApiService>().imageHeaders;
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (breed.previewImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: breed.previewImage!,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  httpHeaders: headers,
                ),
              ),
            if (breed.previewImage != null) const SizedBox(height: 16),
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
                  label: AppStrings.detailCountry,
                  value: breed.origin,
                ),
                CharacteristicChip(
                  label: AppStrings.detailTemperament,
                  value: breed.temperament,
                ),
                CharacteristicChip(
                  label: AppStrings.detailLife,
                  value: '${breed.lifeSpan} ${AppStrings.detailLifeYears}',
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
            if (breed.wikipediaUrl != null) ...[
              const SizedBox(height: 24),
              Text(
                '${AppStrings.detailMore}${breed.wikipediaUrl}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
