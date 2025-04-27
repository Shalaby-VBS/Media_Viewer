import 'package:flutter/material.dart';
import 'package:media_viewer/core/enums/media_type_enum.dart';
import 'package:media_viewer/core/widgets/media_viewer.dart';
import 'package:path/path.dart' as path;

class MediaUtils {
  static const _imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
    '.heic',
    '.heif',
    '.tiff',
    '.raw'
  ];

  static const _videoExtensions = [
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.webm',
    '.flv',
    '.wmv',
    '.3gp',
    '.m4v',
    '.ts',
    '.mpeg',
    '.mpg'
  ];

  static final _extensionCache = <String, MediaTypeEnum>{};

  static MediaTypeEnum detectMediaType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();

    return _extensionCache.putIfAbsent(extension, () {
      if (_imageExtensions.contains(extension)) {
        return MediaTypeEnum.image;
      } else if (_videoExtensions.contains(extension)) {
        return MediaTypeEnum.video;
      } else if (extension == '.pdf') {
        return MediaTypeEnum.pdf;
      }
      return MediaTypeEnum.image;
    });
  }

  static bool _isLocalPath(String path) =>
      !path.startsWith(RegExp(r'^(http|https|www\.)'));

  static Future<void> open({
    required BuildContext context,
    required String url,
    List<String>? gallery,
    MediaTypeEnum? type,
    bool? isLocalFile,
    String? title,
    bool showAppBar = true,
    PreferredSizeWidget? appBar,
    Color? backgroundColor,
    bool fullScreen = false,
    int initialIndex = 0,
  }) async {
    final mediaType = type ?? detectMediaType(url);
    final isLocal = isLocalFile ?? _isLocalPath(url);

    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: fullScreen,
        builder: (_) => MediaViewer(
          mediaUrl: url,
          mediaType: mediaType,
          additionalImageUrls: gallery,
          isLocalFile: isLocal,
          title: title,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
