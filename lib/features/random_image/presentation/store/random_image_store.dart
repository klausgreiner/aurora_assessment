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

      logger.info('RandomImageStore.load: Starting precache');
      bool precacheOk = false;
      try {
        precacheOk = await precacheService.precacheUrl(url: newImageUrl, context: context);
        logger.info('RandomImageStore.load: Precache completed with result: $precacheOk');
      } catch (e) {
        logger.error('RandomImageStore.load: Precache threw exception', e);
        if (e is Failure) {
          error = _localizeError(e.message, context);
        } else {
          error = AppLocalizations.of(context)!.errorCouldNotLoadImage;
        }
        return;
      }
      
      if (!context.mounted) {
        logger.warning('RandomImageStore.load: Context not mounted, returning early');
        return;
      }

      if (!precacheOk) {
        logger.warning('RandomImageStore.load: Precache returned false, setting error');
        error = AppLocalizations.of(context)!.errorCouldNotLoadImage;
        return;
      }

      logger.info('RandomImageStore.load: Starting color extraction');
      List<Color> newGradientColors;
      try {
        newGradientColors = await colorExtractor.gradientColors(CachedNetworkImageProvider(newImageUrl));
        if (newGradientColors.isEmpty) {
          logger.warning('RandomImageStore.load: Color extraction returned empty list');
          error = AppLocalizations.of(context)!.errorCouldNotExtractColors;
          return;
        }
        logger.info('RandomImageStore.load: Color extraction completed with ${newGradientColors.length} colors');
      } catch (e, stackTrace) {
        logger.error('RandomImageStore.load: Color extraction failed', e, stackTrace);
        error = AppLocalizations.of(context)!.errorCouldNotExtractColors;
        return;
      }
      
      logger.info('RandomImageStore.load: Setting imageUrl and gradientColors');
      imageUrl = newImageUrl;
      gradientColors = newGradientColors;
      logger.info('RandomImageStore.load: Load completed successfully');
    } catch (e, stackTrace) {
      logger.error('RandomImageStore.load: Exception caught', e, stackTrace);
      if (e is Failure) {
        error = _localizeError(e.message, context);
      } else {
        error = AppLocalizations.of(context)!.errorCouldNotLoadImage;
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
      bool precacheOk = false;
      try {
        precacheOk = await precacheService.precacheUrl(url: newImageUrl, context: context);
        logger.info('RandomImageStore.loadNext: Precache completed with result: $precacheOk');
      } catch (e) {
        logger.error('RandomImageStore.loadNext: Precache threw exception', e);
        if (e is Failure) {
          error = _localizeError(e.message, context);
        } else {
          error = AppLocalizations.of(context)!.errorCouldNotLoadImage;
        }
        return;
      }
      
      if (!context.mounted) {
        logger.warning('RandomImageStore.loadNext: Context not mounted, returning early');
        return;
      }

      if (!precacheOk) {
        logger.warning('RandomImageStore.loadNext: Precache returned false, setting error');
        error = AppLocalizations.of(context)!.errorCouldNotLoadImage;
        return;
      }

      logger.info('RandomImageStore.loadNext: Starting color extraction');
      List<Color> newGradientColors;
      try {
        newGradientColors = await colorExtractor.gradientColors(CachedNetworkImageProvider(newImageUrl));
        if (newGradientColors.isEmpty) {
          logger.warning('RandomImageStore.loadNext: Color extraction returned empty list');
          error = AppLocalizations.of(context)!.errorCouldNotExtractColors;
          return;
        }
        logger.info('RandomImageStore.loadNext: Color extraction completed with ${newGradientColors.length} colors');
      } catch (e, stackTrace) {
        logger.error('RandomImageStore.loadNext: Color extraction failed', e, stackTrace);
        error = AppLocalizations.of(context)!.errorCouldNotExtractColors;
        return;
      }

      logger.info('RandomImageStore.loadNext: Calling stageNext');
      stageNext(url: newImageUrl, gradientColors: newGradientColors);
      logger.info('RandomImageStore.loadNext: LoadNext completed successfully');
    } catch (e, stackTrace) {
      logger.error('RandomImageStore.loadNext: Exception caught', e, stackTrace);
      if (e is Failure) {
        error = _localizeError(e.message, context);
      } else {
        error = AppLocalizations.of(context)!.errorCouldNotLoadImage;
      }
    } finally {
      logger.info('RandomImageStore.loadNext: Setting isLoading=false');
      isLoading = false;
    }
  }

  String _localizeError(String errorMessage, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (errorMessage.contains('Image not found') || errorMessage.contains('404')) {
      return l10n.errorImageNotFound;
    } else if (errorMessage.contains('Access denied') || errorMessage.contains('403')) {
      return l10n.errorAccessDenied;
    } else if (errorMessage.contains('Server error') || 
               errorMessage.contains('500') || 
               errorMessage.contains('502') || 
               errorMessage.contains('503')) {
      return l10n.errorServerError;
    } else if (errorMessage.contains('timed out') || errorMessage.contains('Timeout')) {
      return l10n.errorImageLoadTimeout;
    } else if (errorMessage.contains('Network error') || errorMessage.contains('network')) {
      return l10n.errorNetworkError;
    } else if (errorMessage.contains('Connection error') || errorMessage.contains('connection')) {
      return l10n.errorConnectionError;
    } else if (errorMessage.contains('Request timed out')) {
      return l10n.errorRequestTimeout;
    } else {
      return l10n.errorFailedToLoadImage;
    }
  }
}
