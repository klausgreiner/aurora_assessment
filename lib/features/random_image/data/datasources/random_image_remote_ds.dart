import 'package:dio/dio.dart';
import '../models/models.dart';

class RandomImageRemoteDataSource {
  final Dio dio;

  RandomImageRemoteDataSource(this.dio);

  Future<RandomImageModel> fetch() async {
    final response = await dio.get('/image/');
    return RandomImageModel.fromJson(response.data);
  }
}
