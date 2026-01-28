import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/core.dart';
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
    store.load();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: store.isLoading && store.imageUrl == null
                              ? Skeletonizer(
                                  enabled: true,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(color: Colors.white),
                                    ),
                                  ),
                                )
                              : store.imageUrl != null
                              ? ImageView(
                                  imageUrl: store.imageUrl!,
                                  isLoading: false,
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 32),
                        Semantics(
                          label: 'Load another random image',
                          button: true,
                          child: PullingColorButton(
                            isLoading: store.isLoading,
                            gradientColors: store.gradientColors,
                            onPressed: store.isLoading ? null : store.load,
                          ),
                        ),
                        if (store.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Semantics(
                              label: 'Error message',
                              child: Text(
                                store.error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    "Tap 'Another' for a new image",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
