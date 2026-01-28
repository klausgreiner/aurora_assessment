import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final String? imageUrl;
  final String? nextImageUrl;
  final VoidCallback? onNextImageDecoded;
  final VoidCallback? onCrossfadeComplete;

  const ImageView({
    super.key,
    this.imageUrl,
    this.nextImageUrl,
    this.onNextImageDecoded,
    this.onCrossfadeComplete,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  String? _currentUrl;
  String? _nextUrl;
  bool _nextDecoded = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.imageUrl;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCrossfadeComplete?.call();
        setState(() {
          _currentUrl = _nextUrl ?? _currentUrl;
          _nextUrl = null;
          _nextDecoded = false;
          _controller.value = 0;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ImageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.imageUrl != oldWidget.imageUrl) {
      _currentUrl = widget.imageUrl;
    }

    final candidate = widget.nextImageUrl;
    if (candidate != null &&
        candidate != _currentUrl &&
        candidate != _nextUrl &&
        !_controller.isAnimating) {
      _startNext(candidate);
    }
  }

  Future<void> _startNext(String url) async {
    setState(() {
      _nextUrl = url;
      _nextDecoded = false;
    });

    final provider = CachedNetworkImageProvider(url);
    final stream = provider.resolve(createLocalImageConfiguration(context));

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        if (!mounted) return;
        setState(() {
          _nextDecoded = true;
        });
        widget.onNextImageDecoded?.call();
        _controller.forward(from: 0);
      },
      onError: (error, stackTrace) {
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildImage(String url) {
    return SizedBox.expand(
      child: Image(
        image: CachedNetworkImageProvider(url),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.red[100],
          child: Icon(Icons.error, color: Colors.red[400]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_currentUrl == null)
              const SizedBox.expand()
            else
              _buildImage(_currentUrl!),
            if (_nextUrl != null)
              FadeTransition(opacity: _opacity, child: _buildImage(_nextUrl!)),
            if (_nextUrl != null && !_nextDecoded) const SizedBox.expand(),
          ],
        ),
      ),
    );
  }
}
