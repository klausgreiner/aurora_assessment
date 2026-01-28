import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePrecacheService {
  Future<bool> precacheUrl({
    required String url,
    required BuildContext context,
  }) async {
    final provider = CachedNetworkImageProvider(url);
    final completer = Completer<bool>();
    final stream = provider.resolve(createLocalImageConfiguration(context));

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        if (!completer.isCompleted) completer.complete(true);
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        PaintingBinding.instance.imageCache.evict(provider);
        if (!completer.isCompleted) completer.complete(false);
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);
    return completer.future;
  }
}