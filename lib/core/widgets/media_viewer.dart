// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:media_viewer/core/enums/media_type_enum.dart';
import 'package:media_viewer/core/widgets/custom_app_bar.dart';
import 'package:media_viewer/core/widgets/image_viewer.dart';
import 'package:media_viewer/core/widgets/pdf_viewer.dart';
import 'package:media_viewer/core/widgets/video_viewer.dart';

class MediaViewer extends StatelessWidget {
  final String mediaUrl;
  final MediaTypeEnum mediaType;
  final String? title;
  final bool isLocalFile;
  final Color? backgroundColor;
  final List<String>? additionalImageUrls;

  const MediaViewer({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
    this.title,
    this.isLocalFile = false,
    this.backgroundColor,
    this.additionalImageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.black,
      appBar: CustomAppBar(
        title: title ?? _getDefaultTitle(),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: backgroundColor ?? Colors.black,
        elevation: 0,
      ),
      body: _buildMediaContent(),
    );
  }

  Widget _buildMediaContent() {
    switch (mediaType) {
      case MediaTypeEnum.image:
        return ImageViewer(
          imageUrl: mediaUrl,
          galleryItems: additionalImageUrls,
          isLocalFile: isLocalFile,
          backgroundColor: backgroundColor,
        );
      case MediaTypeEnum.video:
        return VideoViewer(
          videoUrl: mediaUrl,
          isLocalFile: isLocalFile,
        );
      case MediaTypeEnum.pdf:
        return PdfViewer(
          pdfUrl: mediaUrl,
          isLocalFile: isLocalFile,
        );
    }
  }

  String _getDefaultTitle() {
    switch (mediaType) {
      case MediaTypeEnum.image:
        return additionalImageUrls != null && additionalImageUrls!.isNotEmpty
            ? 'Image Gallery'
            : 'Image Viewer';
      case MediaTypeEnum.video:
        return 'Video Player';
      case MediaTypeEnum.pdf:
        return 'PDF Viewer';
    }
  }
}
