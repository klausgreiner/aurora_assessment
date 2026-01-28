import '../../../../core/core.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

class RandomImageRepositoryImpl implements RandomImageRepository {
  final RandomImageRemoteDataSource remote;

  RandomImageRepositoryImpl(this.remote);

  @override
  Future<RandomImage> getRandomImage() async {
    try {
      return await remote.fetch();
    } catch (e) {
      throw NetworkFailure('Failed to load image');
    }
  }
}
