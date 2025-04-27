import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_viewer/core/widgets/loader_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget {
  final String imageUrl;
  final List<String>? galleryItems;
  final bool isLocalFile;
  final Color? backgroundColor;
  final int initialIndex;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    this.galleryItems,
    this.isLocalFile = false,
    this.backgroundColor,
    this.initialIndex = 0,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentPage = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isGallery =>
      widget.galleryItems != null && widget.galleryItems!.isNotEmpty;
  List<String> get _allImages => _isGallery
      ? [widget.imageUrl, ...widget.galleryItems!]
      : [widget.imageUrl];

  @override
  Widget build(BuildContext context) =>
      _isGallery ? _buildGallery() : _buildSingleImage();

  Widget _buildSingleImage() => PhotoView(
        imageProvider: _getImageProvider(widget.imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: BoxDecoration(color: widget.backgroundColor),
        loadingBuilder: _buildLoader,
        errorBuilder: _buildError,
      );

  Widget _buildGallery() => Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: _allImages.length,
            builder: (_, index) => PhotoViewGalleryPageOptions(
              imageProvider: _getImageProvider(_allImages[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
            ),
            backgroundDecoration: BoxDecoration(color: widget.backgroundColor),
            loadingBuilder: _buildLoader,
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          if (_allImages.length > 1)
            Positioned(
              bottom: 30.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text('${_currentPage + 1} / ${_allImages.length}'),
                ),
              ),
            ),
        ],
      );

  ImageProvider _getImageProvider(String url) => widget.isLocalFile
      ? FileImage(File(url))
      : NetworkImage(url) as ImageProvider;

  Widget _buildLoader(_, __) => const LoaderWidget();

  Widget _buildError(_, __, ___) =>
      const Center(child: Icon(Icons.broken_image));
}
