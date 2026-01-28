import '../../domain/entities/entities.dart';

class RandomImageModel extends RandomImage {
  RandomImageModel(super.url);

  factory RandomImageModel.fromJson(Map<String, dynamic> json) {
    return RandomImageModel(json['url'] as String);
  }
}
