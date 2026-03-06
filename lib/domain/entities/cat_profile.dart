import 'package:hw_1/domain/entities/breed.dart';

class CatProfile {
  const CatProfile({
    required this.id,
    required this.imageUrl,
    required this.breed,
  });

  final String id;
  final String imageUrl;
  final Breed breed;

  factory CatProfile.fromSearchJson(Map<String, dynamic> json) {
    final breeds = json['breeds'];
    if (breeds is! List || breeds.isEmpty) {
      throw ArgumentError('Cat image does not contain breed info');
    }
    final breedJson = breeds.first;
    if (breedJson is! Map<String, dynamic>) {
      throw ArgumentError('Invalid breed payload');
    }
    return CatProfile(
      id: json['id']?.toString() ?? '',
      imageUrl: json['url']?.toString() ?? '',
      breed: Breed.fromJson(breedJson),
    );
  }
}
