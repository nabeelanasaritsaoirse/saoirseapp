import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppImage {
  static Widget network(
    String src, {
    Key? key,
    double? scale,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    FilterQuality filterQuality = FilterQuality.low,
    bool isAntiAlias = false,
    Map<String, String>? headers,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return CachedNetworkImage(
      key: key,
      imageUrl: src,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      httpHeaders: headers,
      filterQuality: filterQuality,
      fadeInDuration: const Duration(milliseconds: 100),
      memCacheWidth: cacheWidth ??
          (width != null && width.isFinite ? (width * 3).toInt() : 400),
      memCacheHeight: cacheHeight ??
          (height != null && height.isFinite ? (height * 3).toInt() : 400),
      placeholder: loadingBuilder != null
          ? (context, url) => loadingBuilder(
                context,
                const SizedBox(),
                const ImageChunkEvent(
                  expectedTotalBytes: 100,
                  cumulativeBytesLoaded: 50,
                ),
              )
          : null,
      errorWidget: errorBuilder != null
          ? (context, url, error) =>
              errorBuilder(context, error, StackTrace.empty)
          : (context, url, error) =>
              const Center(child: Icon(Icons.broken_image)),
    );
  }
}
