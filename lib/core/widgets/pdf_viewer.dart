import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  final String pdfUrl;
  final bool isLocalFile;

  const PdfViewer({
    super.key,
    required this.pdfUrl,
    this.isLocalFile = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return isLocalFile
          ? SfPdfViewer.file(
              File(pdfUrl),
              canShowScrollHead: true,
              enableDoubleTapZooming: true,
            )
          : SfPdfViewer.network(
              pdfUrl,
              canShowScrollHead: true,
              enableDoubleTapZooming: true,
            );
    } catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 50.sp,
              color: Colors.grey,
            ),
            16.verticalSpace,
            const Text('Failed to load PDF file.'),
          ],
        ),
      );
    }
  }
}
