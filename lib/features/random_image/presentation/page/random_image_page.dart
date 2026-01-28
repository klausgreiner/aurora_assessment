import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../store/store.dart';
import '../widgets/widgets.dart';

class RandomImagePage extends StatefulWidget {
  const RandomImagePage({super.key});

  @override
  State<RandomImagePage> createState() => _RandomImagePageState();
}

class _RandomImagePageState extends State<RandomImagePage> {
  late final RandomImageStore store;

  @override
  void initState() {
    super.initState();
    store = getIt<RandomImageStore>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage();
    });
  }

  Future<void> _loadImage() async {
    store.isLoading = true;
    store.error = null;

    try {
      final getRandomImage = getIt<GetRandomImage>();
      final image = await getRandomImage();
      final newImageUrl = image.url;

      final precacheService = getIt<ImagePrecacheService>();
      final ok = await precacheService.precacheUrl(
        url: newImageUrl,
        context: context,
      );
      if (!ok) {
        store.error = 'Could not load that image. Keeping the current one.';
        return;
      }

      final colorExtractor = getIt<ImageColorExtractor>();
      final newGradientColors = await colorExtractor.gradientColors(
        CachedNetworkImageProvider(newImageUrl),
      );

      store.imageUrl = newImageUrl;

      await Future.delayed(const Duration(milliseconds: 120));

      store.gradientColors = newGradientColors;
    } catch (e) {
      store.error = 'Could not load that image. Keeping the current one.';
    } finally {
      store.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AnimatedContainer(
        duration: const Duration(milliseconds: 650),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: store.gradientColors,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ImageView(imageUrl: store.imageUrl),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 32,
                        child: AnimatedOpacity(
                          opacity: store.error != null ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Semantics(
                            label: 'Image load message',
                            child: Text(
                              store.error ?? '',
                              style: TextStyle(
                                color: Colors.red[400],
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Semantics(
                        label: 'Load another random image',
                        button: true,
                        child: PullingColorButton(
                          isLoading: store.isLoading,
                          gradientColors: store.gradientColors,
                          onPressed: store.isLoading ? null : _loadImage,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Tap 'Another' for a new image",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
