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

  _RandomImageStore(this.getRandomImage, this.colorExtractor, this.precacheService);

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
    isLoading = true;
    error = null;

    try {
      final image = await getRandomImage();
      final newImageUrl = image.url;

      final results = await Future.wait([
        precacheService.precacheUrl(url: newImageUrl, context: context),
        colorExtractor.gradientColors(CachedNetworkImageProvider(newImageUrl)),
      ]);
      if (!context.mounted) return;

      final ok = results[0] as bool;
      if (!ok) {
        error = 'Could not load that image. Try again.';
        return;
      }

      final newGradientColors = results[1] as List<Color>;
      imageUrl = newImageUrl;
      gradientColors = newGradientColors;
    } catch (e) {
      error = 'Could not load that image. Try again.';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadNext({required BuildContext context}) async {
    isLoading = true;
    error = null;

    try {
      final image = await getRandomImage();
      final newImageUrl = image.url;

      final results = await Future.wait([
        precacheService.precacheUrl(url: newImageUrl, context: context),
        colorExtractor.gradientColors(CachedNetworkImageProvider(newImageUrl)),
      ]);
      if (!context.mounted) return;

      final ok = results[0] as bool;
      if (!ok) {
        error = 'Could not load that image. Try again.';
        return;
      }

      final newGradientColors = results[1] as List<Color>;
      stageNext(url: newImageUrl, gradientColors: newGradientColors);
    } catch (e) {
      error = 'Could not load that image. Try again.';
    } finally {
      isLoading = false;
    }
  }
}
