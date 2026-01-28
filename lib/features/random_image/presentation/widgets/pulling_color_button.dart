import 'dart:ui';
import 'package:flutter/material.dart';

class PullingColorButton extends StatefulWidget {
  final bool isLoading;
  final List<Color> gradientColors;
  final VoidCallback? onPressed;

  const PullingColorButton({
    super.key,
    required this.isLoading,
    required this.gradientColors,
    this.onPressed,
  });

  @override
  State<PullingColorButton> createState() => _PullingColorButtonState();
}

class _PullingColorButtonState extends State<PullingColorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _gradientAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _gradientAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _textOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    if (widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(PullingColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _animationController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getContrastColor(List<Color> colors) {
    if (colors.isEmpty) return Colors.black;
    final avgColor = colors.first;
    final luminance = avgColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final contrastColor = _getContrastColor(widget.gradientColors);

    return AnimatedBuilder(
      animation: Listenable.merge([_gradientAnimation, _textOpacityAnimation]),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: widget.isLoading
                      ? Alignment(_gradientAnimation.value, 0)
                      : Alignment.centerLeft,
                  end: widget.isLoading
                      ? Alignment(_gradientAnimation.value + 1, 0)
                      : Alignment.centerRight,
                  colors: widget.gradientColors,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPressed,
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Opacity(
                              opacity: 1 - _textOpacityAnimation.value,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(
                                        _gradientAnimation.value,
                                        0,
                                      ),
                                      end: Alignment(
                                        _gradientAnimation.value + 1,
                                        0,
                                      ),
                                      colors: [
                                        ...widget.gradientColors.map(
                                          (c) => c.withValues(alpha: 0.25),
                                        ),
                                        ...widget.gradientColors.map(
                                          (c) => c.withValues(alpha: 0.85),
                                        ),
                                        ...widget.gradientColors.map(
                                          (c) => c.withValues(alpha: 0.25),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          child: Opacity(
                            opacity: _textOpacityAnimation.value,
                            child: Text(
                              'Another',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: contrastColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
