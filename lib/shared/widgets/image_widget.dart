import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/services/logging/app_logger.dart';
import '../../themes/theme_tailor/theme_colors.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageNetworkUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.placeholder,
  });

  final String? imageNetworkUrl;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit? fit;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    if (imageNetworkUrl == null || imageNetworkUrl!.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: placeholder ??
            DecoratedBox(
              decoration: BoxDecoration(
                shape: borderRadius == null
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                borderRadius: borderRadius != null
                    ? BorderRadius.circular(borderRadius!)
                    : null,
                color: context.surface,
              ),
              child: Icon(Icons.image_outlined, color: context.gray3),
            ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        key: ValueKey(imageNetworkUrl),
        imageUrl: imageNetworkUrl!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius != null
                ? BorderRadius.circular(borderRadius!)
                : null,
            shape: borderRadius == null ? BoxShape.circle : BoxShape.rectangle,
            color: context.surface,
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        ),
        useOldImageOnUrlChange: true,
        errorListener: (value) => AppLogger.warning('Image failed: $value'),
      ),
    );
  }
}
