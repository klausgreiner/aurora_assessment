import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/core.dart';
import '../../../../core/di/di.dart';
import '../store/store.dart';
import '../widgets/widgets.dart';

class RandomImagePage extends StatefulWidget {
  const RandomImagePage({super.key});

  @override
  State<RandomImagePage> createState() => _RandomImagePageState();
}

class _RandomImagePageState extends State<RandomImagePage> {
  late final RandomImageStore store;
  late final Logger logger;

  @override
  void initState() {
    super.initState();
    store = getIt<RandomImageStore>();
    logger = getIt<Logger>();
  }

  Future<void> _loadImage() async {
    logger.info('RandomImagePage._loadImage: Button pressed, isLoading=${store.isLoading}');
    await store.loadNext(context: context);
    logger.info('RandomImagePage._loadImage: loadNext completed, isLoading=${store.isLoading}');
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
                      child: ImageView(
                        imageUrl: store.imageUrl,
                        nextImageUrl: store.nextImageUrl,
                        onNextImageDecoded: store.applyNextColors,
                        onCrossfadeComplete: store.commitNextImage,
                      ),
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
