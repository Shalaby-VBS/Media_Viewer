import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_viewer/core/extensions/navigations.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    dynamic title,
    BuildContext? context,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    super.leadingWidth,
    super.actions,
    super.bottom,
    super.elevation = 0,
    super.centerTitle,
    super.backgroundColor,
    super.foregroundColor,
    super.shape,
    super.toolbarHeight,
    super.titleSpacing,
    TextStyle? titleTextStyle,
  }) : super(
         leading: _buildLeading(context, leading, automaticallyImplyLeading),
         title: _buildTitle(title, titleTextStyle),
       );

  static Widget? _buildLeading(
    BuildContext? context,
    Widget? leading,
    bool automaticallyImplyLeading,
  ) {
    if (leading != null) return leading;
    if (!automaticallyImplyLeading) return null;
    if (context == null || !context.canPop) return null;
    return const BackButton();
  }

  static Widget? _buildTitle(dynamic title, TextStyle? titleTextStyle) {
    if (title == null) return null;

    if (title is String) {
      return Text(
        title,
        style:
            titleTextStyle ?? TextStyle(fontSize: 16.sp, color: Colors.black),
      );
    }

    if (title is Widget) {
      return title;
    }

    throw ArgumentError('Title must be either String or Widget');
  }
}
