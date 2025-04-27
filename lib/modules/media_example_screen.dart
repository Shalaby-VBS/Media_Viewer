import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_viewer/core/utils/media_utils.dart';
import 'package:media_viewer/core/widgets/custom_app_bar.dart';

class MediaExampleScreen extends StatelessWidget {
  const MediaExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Media Viewer Example'),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          spacing: 6.h,
          children: [
            _buildMediaButton(
              context: context,
              title: 'View Image',
              icon: Icons.image,
              onPressed:
                  () => MediaUtils.open(
                    context: context,
                    url: 'https://picsum.photos/800/600',
                    title: 'Sample Image',
                  ),
            ),
            _buildMediaButton(
              context: context,
              title: 'View Video',
              icon: Icons.video_library,
              onPressed:
                  () => MediaUtils.open(
                    context: context,
                    url:
                        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                    title: 'Sample Video',
                  ),
            ),
            _buildMediaButton(
              context: context,
              title: 'View PDF',
              icon: Icons.picture_as_pdf,
              onPressed:
                  () => MediaUtils.open(
                    context: context,
                    url:
                        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                    title: 'Sample PDF',
                  ),
            ),
            _buildMediaButton(
              context: context,
              title: 'Image Gallery',
              icon: Icons.photo_library,
              onPressed:
                  () => MediaUtils.open(
                    context: context,
                    url: 'https://picsum.photos/id/1/800/600',
                    gallery: [
                      'https://picsum.photos/id/10/800/600',
                      'https://picsum.photos/id/100/800/600',
                      'https://picsum.photos/id/1000/800/600',
                      'https://picsum.photos/id/1001/800/600',
                    ],
                    title: 'Image Gallery',
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            Icon(icon),
            SizedBox(width: 16.w),
            Text(title),
          ],
        ),
      ),
    );
  }
}
