// Flutter imports:
import 'package:flutter/material.dart';

/// Loading widget with different variants
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.variant = LoadingVariant.circular,
    this.size = LoadingSize.medium,
    this.message,
    this.color,
  });

  final LoadingVariant variant;
  final LoadingSize size;
  final String? message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loadingColor = color ?? colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoadingIndicator(loadingColor),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    final indicatorSize = _getIndicatorSize();

    switch (variant) {
      case LoadingVariant.circular:
        return SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: _getStrokeWidth(),
          ),
        );

      case LoadingVariant.linear:
        return SizedBox(
          width: indicatorSize * 2,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: _getStrokeWidth(),
          ),
        );

      case LoadingVariant.dots:
        return SizedBox(
          width: indicatorSize,
          height: indicatorSize / 4,
          child: _DotsLoadingIndicator(
            color: color,
            size: _getStrokeWidth() * 2,
          ),
        );

      case LoadingVariant.pulse:
        return _PulseLoadingIndicator(color: color, size: indicatorSize);
    }
  }

  double _getIndicatorSize() {
    switch (size) {
      case LoadingSize.small:
        return 24;
      case LoadingSize.medium:
        return 40;
      case LoadingSize.large:
        return 56;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }
}

/// Dots loading indicator
class _DotsLoadingIndicator extends StatefulWidget {
  const _DotsLoadingIndicator({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<_DotsLoadingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();

    _startAnimations();
  }

  void _startAnimations() {
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      3,
      (index) => AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) => Container(
          margin: EdgeInsets.symmetric(horizontal: widget.size / 4),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withValues(
              alpha: 0.3 + (_animations[index].value * 0.7),
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
  );
}

/// Pulse loading indicator
class _PulseLoadingIndicator extends StatefulWidget {
  const _PulseLoadingIndicator({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_PulseLoadingIndicator> createState() => _PulseLoadingIndicatorState();
}

class _PulseLoadingIndicatorState extends State<_PulseLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.3 + (_animation.value * 0.7)),
        shape: BoxShape.circle,
      ),
    ),
  );
}

/// Loading variant enum
enum LoadingVariant { circular, linear, dots, pulse }

/// Loading size enum
enum LoadingSize { small, medium, large }
