import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoaderWidget extends StatelessWidget {
  final Color? color;
  final double? value;

  const LoaderWidget({
    super.key,
    this.color,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: value,
        color: color ?? Colors.white,
        strokeWidth: 2.sp,
      ),
    );
  }
}
