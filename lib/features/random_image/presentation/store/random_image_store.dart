import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/core.dart';
import '../../domain/usecases/usecases.dart';

part 'random_image_store.g.dart';

class RandomImageStore = _RandomImageStore with _$RandomImageStore;

abstract class _RandomImageStore with Store {
  final GetRandomImage getRandomImage;
  final ImageColorExtractor colorExtractor;
  final ImagePrecacheService precacheService;
  final Logger logger;

  _RandomImageStore(this.getRandomImage, this.colorExtractor, this.precacheService, this.logger) {
    reaction((_) => isLoading, (bool value) {
      logger.info('RandomImageStore: isLoading changed to $value');
    });
  }

  @observable
  String? imageUrl;

  @observable
  List<Color> gradientColors = [Colors.black, Colors.grey];

  @observable
  String? nextImageUrl;

  @observable
  List<Color>? nextGradientColors;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  void stageNext({
    required String url,
    required List<Color> gradientColors,
  }) {
    nextImageUrl = url;
    nextGradientColors = gradientColors;
  }

  @action
  void applyNextColors() {
    final colors = nextGradientColors;
    if (colors == null) return;
    gradientColors = colors;
  }

  @action
  void commitNextImage() {
    final url = nextImageUrl;
    if (url == null) return;
    imageUrl = url;
    nextImageUrl = null;
    nextGradientColors = null;
  }

  @action
  Future<void> load({required BuildContext context}) async {
    logger.info('RandomImageStore.load: Starting load');
    isLoading = true;
    error = null;

    try {
      logger.info('RandomImageStore.load: Calling getRandomImage()');
      final image = await getRandomImage();
      final newImageUrl = image.url;
      logger.info('RandomImageStore.load: Got image URL: $newImageUrl');

      logger.info('RandomImageStore.load: Starting Future.wait for precache and color extraction');
      final results = await Future.wait([
        precacheService.precacheUrl(url: newImageUrl, context: context),
        colorExtractor.gradientColors(CachedNetworkImageProvider(newImageUrl)),
      ]);
      logger.info('RandomImageStore.load: Future.wait completed');
      
      if (!context.mounted) {
        logger.warning('RandomImageStore.load: Context not mounted, returning early');
        return;
      }

      final ok = results[0] as bool;
      logger.info('RandomImageStore.load: Precache result: $ok');
      if (!ok) {
        logger.warning('RandomImageStore.load: Precache failed, setting error');
        error = 'Could not load that image. Try again.';
        return;
      }

      final newGradientColors = results[1] as List<Color>;
      logger.info('RandomImageStore.load: Setting imageUrl and gradientColors');
      imageUrl = newImageUrl;
      gradientColors = newGradientColors;
      logger.info('RandomImageStore.load: Load completed successfully');
    } catch (e, stackTrace) {
      logger.error('RandomImageStore.load: Exception caught', e, stackTrace);
      if (e is Failure) {
        error = e.message;
      } else {
        error = 'Could not load that image. Try again.';
      }
    } finally {
      logger.info('RandomImageStore.load: Setting isLoading=false');
      isLoading = false;
    }
  }

  @action
  Future<void> loadNext({required BuildContext context}) async {
    logger.info('RandomImageStore.loadNext: Starting loadNext - isLoading was: $isLoading');
    isLoading = true;
    error = null;
    logger.info('RandomImageStore.loadNext: Set isLoading=true, error=null');

    try {
      logger.info('RandomImageStore.loadNext: Calling getRandomImage()');
      final image = await getRandomImage();
      final newImageUrl = image.url;
      logger.info('RandomImageStore.loadNext: Got image URL: $newImageUrl');

      logger.info('RandomImageStore.loadNext: Starting Future.wait for precache and color extraction');
      final results = await Future.wait([
        precacheService.precacheUrl(url: newImageUrl, context: context),
        colorExtractor.gradientColors(CachedNetworkImageProvider(newImageUrl)),
      ]);
      logger.info('RandomImageStore.loadNext: Future.wait completed');
      
      if (!context.mounted) {
        logger.warning('RandomImageStore.loadNext: Context not mounted, returning early');
        return;
      }

      final ok = results[0] as bool;
      logger.info('RandomImageStore.loadNext: Precache result: $ok');
      if (!ok) {
        logger.warning('RandomImageStore.loadNext: Precache failed, setting error');
        error = 'Could not load that image. Try again.';
        return;
      }

      final newGradientColors = results[1] as List<Color>;
      logger.info('RandomImageStore.loadNext: Calling stageNext');
      stageNext(url: newImageUrl, gradientColors: newGradientColors);
      logger.info('RandomImageStore.loadNext: LoadNext completed successfully');
    } catch (e, stackTrace) {
      logger.error('RandomImageStore.loadNext: Exception caught', e, stackTrace);
      if (e is Failure) {
        error = e.message;
      } else {
        error = 'Could not load that image. Try again.';
      }
    } finally {
      logger.info('RandomImageStore.loadNext: Setting isLoading=false');
      isLoading = false;
    }
  }
}
