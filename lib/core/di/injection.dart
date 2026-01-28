import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../image/image.dart';
import '../logger/logger.dart';
import '../theme/theme.dart';
import '../../features/random_image/data/data.dart';
import '../../features/random_image/domain/domain.dart';
import '../../features/random_image/presentation/presentation.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerLazySingleton<Logger>(() => AppLogger());

  getIt.registerLazySingleton(
    () => Dio(BaseOptions(
      baseUrl: 'https://november7-730026606190.europe-west1.run.app',
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
    )),
  );

  getIt.registerLazySingleton(() => ImageColorExtractor());
  getIt.registerLazySingleton(() => ImagePrecacheService(getIt()));

  getIt.registerLazySingleton(
    () => RandomImageRemoteDataSource(getIt(), getIt()),
  );

  getIt.registerLazySingleton<RandomImageRepository>(
    () => RandomImageRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton(
    () => GetRandomImage(getIt()),
  );

  getIt.registerLazySingleton(
    () => RandomImageStore(getIt(), getIt(), getIt(), getIt()),
  );
}
