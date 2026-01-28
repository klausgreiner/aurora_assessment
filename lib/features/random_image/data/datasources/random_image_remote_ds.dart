import 'package:dio/dio.dart';
import '../../../../core/core.dart';
import '../models/models.dart';

class RandomImageRemoteDataSource {
  final Dio dio;
  final Logger logger;

  RandomImageRemoteDataSource(this.dio, this.logger);

  Future<RandomImageModel> fetch() async {
    logger.info('RandomImageRemoteDataSource.fetch: Starting API call to /image/');
    try {
      final response = await dio.get('/image/');
      logger.info('RandomImageRemoteDataSource.fetch: API call successful, status: ${response.statusCode}');
      return RandomImageModel.fromJson(response.data);
    } catch (e, stackTrace) {
      logger.error('RandomImageRemoteDataSource.fetch: API call failed', e, stackTrace);
      rethrow;
    }
  }
}
