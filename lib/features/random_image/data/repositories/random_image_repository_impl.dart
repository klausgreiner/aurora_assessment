import 'package:dio/dio.dart';
import '../../../../core/core.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

class RandomImageRepositoryImpl implements RandomImageRepository {
  final RandomImageRemoteDataSource remote;
  final Logger logger;

  RandomImageRepositoryImpl(this.remote, this.logger);

  @override
  Future<RandomImage> getRandomImage() async {
    logger.info('RandomImageRepositoryImpl.getRandomImage: Starting');
    try {
      final result = await remote.fetch();
      logger.info('RandomImageRepositoryImpl.getRandomImage: Success');
      return result;
    } on DioException catch (e) {
      logger.error('RandomImageRepositoryImpl.getRandomImage: DioException type: ${e.type}', e);
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkFailure('Request timed out. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure('Connection error. Please check your internet.');
      } else {
        throw NetworkFailure('Failed to load image. Please try again.');
      }
    } catch (e, stackTrace) {
      logger.error('RandomImageRepositoryImpl.getRandomImage: Unexpected error', e, stackTrace);
      if (e is Failure) {
        rethrow;
      }
      throw NetworkFailure('Failed to load image. Please try again.');
    }
  }
}
