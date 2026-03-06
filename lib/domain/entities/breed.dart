import 'package:hw_1/domain/utils/app_strings.dart';

class Breed {
  const Breed({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.temperament,
    required this.lifeSpan,
    this.energyLevel,
    this.affectionLevel,
    this.intelligence,
    this.wikipediaUrl,
    this.imageUrl,
    this.referenceImageId,
  });

  final String id;
  final String name;
  final String origin;
  final String description;
  final String temperament;
  final String lifeSpan;
  final int? energyLevel;
  final int? affectionLevel;
  final int? intelligence;
  final String? wikipediaUrl;
  final String? imageUrl;
  final String? referenceImageId;

  String? get previewImage {
    if (imageUrl != null) {
      return imageUrl;
    }
    if (referenceImageId == null) {
      return null;
    }
    return 'https://cdn2.thecatapi.com/images/$referenceImageId.jpg';
  }

  factory Breed.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final refImage = json['reference_image_id']?.toString();
    return Breed(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      origin: json['origin']?.toString() ?? AppStrings.breedUnknownOrigin,
      description:
          json['description']?.toString() ?? AppStrings.breedNoDescription,
      temperament:
          json['temperament']?.toString() ?? AppStrings.breedNoTemperament,
      lifeSpan: json['life_span']?.toString() ?? AppStrings.breedNoLifeSpan,
      energyLevel: _intOrNull(json['energy_level']),
      affectionLevel: _intOrNull(json['affection_level']),
      intelligence: _intOrNull(json['intelligence']),
      wikipediaUrl: json['wikipedia_url']?.toString(),
      imageUrl: image is Map<String, dynamic> ? image['url']?.toString() : null,
      referenceImageId: refImage,
    );
  }

  static int? _intOrNull(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString());
  }
}
