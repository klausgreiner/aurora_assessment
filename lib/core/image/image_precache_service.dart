import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../error/error.dart';
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
          completer.completeError(
            _convertToFailure(error, url),
            stackTrace,
          );
        }
        stream.removeListener(listener);
      },
    );

    timeoutTimer = Timer(const Duration(seconds: 3), () {
      final duration = DateTime.now().difference(startTime);
      logger.warning('ImagePrecacheService.precacheUrl: Timeout after ${duration.inMilliseconds}ms for $url');
      if (!completer.isCompleted) {
        PaintingBinding.instance.imageCache.evict(provider);
        completer.completeError(
          NetworkFailure('Image load timed out after 3 seconds'),
        );
        stream.removeListener(listener);
      }
    });

    stream.addListener(listener);
    
    try {
      final result = await completer.future;
      logger.info('ImagePrecacheService.precacheUrl: Completed with result=$result');
      return result;
    } catch (e) {
      logger.error('ImagePrecacheService.precacheUrl: Exception thrown', e);
      rethrow;
    }
  }

  Failure _convertToFailure(Object error, String url) {
    final errorString = error.toString();
    logger.info('ImagePrecacheService._convertToFailure: Converting error: $errorString');
    
    if (errorString.contains('404')) {
      return NetworkFailure('Image not found (404). The image may have been removed.');
    } else if (errorString.contains('403')) {
      return NetworkFailure('Access denied (403). Cannot load this image.');
    } else if (errorString.contains('500') || errorString.contains('502') || errorString.contains('503')) {
      return NetworkFailure('Server error. Please try again.');
    } else if (errorString.contains('timeout') || errorString.contains('Timeout')) {
      return NetworkFailure('Image load timed out. Please try again.');
    } else if (errorString.contains('network') || errorString.contains('Network')) {
      return NetworkFailure('Network error. Please check your connection.');
    } else {
      return NetworkFailure('Failed to load image. Please try again.');
    }
  }
}