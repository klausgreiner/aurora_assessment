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

  _RandomImageStore(this.getRandomImage, this.colorExtractor);

  @observable
  String? imageUrl;

  @observable
  List<Color> gradientColors = [Colors.black, Colors.grey];

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> load() async {
    isLoading = true;
    error = null;

    try {
      final image = await getRandomImage();
      final newImageUrl = image.url;

      final provider = CachedNetworkImageProvider(newImageUrl);
      final newGradientColors = await colorExtractor.gradientColors(provider);

      imageUrl = newImageUrl;

      await Future.delayed(const Duration(milliseconds: 120));

      gradientColors = newGradientColors;
    } catch (e) {
      error = 'Something went wrong';
    } finally {
      isLoading = false;
    }
  }
}
