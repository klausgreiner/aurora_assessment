import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetRandomImage {
  final RandomImageRepository repository;

  GetRandomImage(this.repository);

  Future<RandomImage> call() {
    return repository.getRandomImage();
  }
}
