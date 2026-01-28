import '../entities/entities.dart';

abstract class RandomImageRepository {
  Future<RandomImage> getRandomImage();
}
