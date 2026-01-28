import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../logger/logger.dart';

class ImagePrecacheService {
  final Logger logger;

  ImagePrecacheService(this.logger);

  Future<bool> precacheUrl({
    required String url,
    required BuildContext context,
  }) async {
    logger.info('ImagePrecacheService.precacheUrl: Starting precache for $url');
    final startTime = DateTime.now();
    final provider = CachedNetworkImageProvider(url);
    final completer = Completer<bool>();
    final stream = provider.resolve(createLocalImageConfiguration(context));

    late final ImageStreamListener listener;
    Timer? timeoutTimer;
    
    listener = ImageStreamListener(
      (info, _) {
        final duration = DateTime.now().difference(startTime);
        logger.info('ImagePrecacheService.precacheUrl: Image loaded successfully in ${duration.inMilliseconds}ms');
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        final duration = DateTime.now().difference(startTime);
        logger.error('ImagePrecacheService.precacheUrl: Image load error after ${duration.inMilliseconds}ms', error, stackTrace);
        timeoutTimer?.cancel();
        PaintingBinding.instance.imageCache.evict(provider);
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        stream.removeListener(listener);
      },
    );

    timeoutTimer = Timer(const Duration(seconds: 3), () {
      final duration = DateTime.now().difference(startTime);
      logger.warning('ImagePrecacheService.precacheUrl: Timeout after ${duration.inMilliseconds}ms for $url');
      if (!completer.isCompleted) {
        PaintingBinding.instance.imageCache.evict(provider);
        completer.complete(false);
        stream.removeListener(listener);
      }
    });

    stream.addListener(listener);
    final result = await completer.future;
    logger.info('ImagePrecacheService.precacheUrl: Completed with result=$result');
    return result;
  }
}