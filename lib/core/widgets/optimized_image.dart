// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import '../services/performance_service.dart';
import '../utils/logger.dart';

/// Optimized image widget with caching, compression, and performance monitoring
class OptimizedImage extends StatelessWidget {
  const OptimizedImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.enablePerformanceMonitoring = true,
    this.cacheKey,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 100),
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final bool enablePerformanceMonitoring;
  final String? cacheKey;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheKey: cacheKey,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholder: (context, url) {
        if (enablePerformanceMonitoring) {
          PerformanceService.startImageLoad(imageUrl);
        }

        return placeholder ?? _buildDefaultPlaceholder(colorScheme);
      },
      errorWidget: (context, url, error) {
        AppLogger.error('Failed to load image: $url', error);
        return errorWidget ?? _buildDefaultErrorWidget(colorScheme);
      },
      imageBuilder: (context, imageProvider) {
        if (enablePerformanceMonitoring) {
          PerformanceService.completeImageLoad(imageUrl);
        }

        final image = Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit,
        );

        if (borderRadius != null) {
          return ClipRRect(borderRadius: borderRadius!, child: image);
        }

        return image;
      },
    );

    // Add container with border radius if specified and no imageBuilder
    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildDefaultPlaceholder(ColorScheme colorScheme) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: borderRadius,
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_outlined,
            size: 32,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildDefaultErrorWidget(ColorScheme colorScheme) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: colorScheme.errorContainer,
      borderRadius: borderRadius,
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 32,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(height: 4),
          Text(
            'Failed to load',
            style: TextStyle(fontSize: 12, color: colorScheme.onErrorContainer),
          ),
        ],
      ),
    ),
  );
}

/// Optimized avatar widget
class OptimizedAvatar extends StatelessWidget {
  const OptimizedAvatar({
    required this.imageUrl,
    super.key,
    this.radius = 25,
    this.fallbackIcon = Icons.person,
    this.backgroundColor,
    this.foregroundColor,
    this.enablePerformanceMonitoring = true,
  });

  final String? imageUrl;
  final double radius;
  final IconData fallbackIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool enablePerformanceMonitoring;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
        child: Icon(
          fallbackIcon,
          size: radius * 0.8,
          color: foregroundColor ?? colorScheme.onPrimaryContainer,
        ),
      );
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        memCacheWidth: (radius * 2 * 2).round(), // 2x for high DPI
        memCacheHeight: (radius * 2 * 2).round(),
        placeholder: (context, url) {
          if (enablePerformanceMonitoring) {
            PerformanceService.startImageLoad(imageUrl!);
          }
          return Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? colorScheme.primaryContainer,
            ),
            child: Center(
              child: SizedBox(
                width: radius * 0.6,
                height: radius * 0.6,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          AppLogger.error('Failed to load avatar image: $url', error);
          return Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? colorScheme.errorContainer,
            ),
            child: Center(
              child: Icon(
                fallbackIcon,
                size: radius * 0.8,
                color: foregroundColor ?? colorScheme.onErrorContainer,
              ),
            ),
          );
        },
        imageBuilder: (context, imageProvider) {
          if (enablePerformanceMonitoring) {
            PerformanceService.completeImageLoad(imageUrl!);
          }
          return Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}

/// Optimized image with hero animation
class OptimizedHeroImage extends StatelessWidget {
  const OptimizedHeroImage({
    required this.imageUrl,
    required this.heroTag,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.onTap,
    this.enablePerformanceMonitoring = true,
  });

  final String imageUrl;
  final String heroTag;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool enablePerformanceMonitoring;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = OptimizedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      enablePerformanceMonitoring: enablePerformanceMonitoring,
    );

    imageWidget = Hero(tag: heroTag, child: imageWidget);

    if (onTap != null) {
      imageWidget = GestureDetector(onTap: onTap, child: imageWidget);
    }

    return imageWidget;
  }
}
