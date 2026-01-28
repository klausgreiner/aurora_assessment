import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String? imageUrl;

  const ImageView({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.linear,
          transitionBuilder: (child, animation) {
            final opacity = CurvedAnimation(
              parent: animation,
              curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
              reverseCurve: const Interval(
                0.0,
                0.45,
                curve: Curves.easeInCubic,
              ),
            );
            return FadeTransition(opacity: opacity, child: child);
          },
          child: imageUrl == null
              ? const SizedBox.expand(key: ValueKey('empty'))
              : SizedBox.expand(
                  key: ValueKey(imageUrl),
                  child: Image(
                    image: CachedNetworkImageProvider(imageUrl!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
