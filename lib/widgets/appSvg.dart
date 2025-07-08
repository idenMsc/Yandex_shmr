import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg extends StatelessWidget {
  final String fileName;
  final double? iconHeight;
  final double? iconWidth;
  final Color? tintColor;
  final ColorFilter? colorFilter;

  const AppSvg({
    super.key,
    required this.fileName,
    this.iconHeight,
    this.iconWidth,
    this.tintColor,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$fileName',
      height: iconHeight,
      width: iconWidth,
      color: tintColor,
      colorFilter: colorFilter,
    );
  }
}
