import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title, subtitle, rightBottomText;
  final int? percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.rightBottomText,
    this.subtitle,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Недвижимость",
    subtitle: "Оценить",
    svgSrc: "assets/icons/check_mark.svg",
    rightBottomText: "",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Автомобиль",
    subtitle: "Оценить",
    svgSrc: "assets/icons/check_mark.svg",
    rightBottomText: "",
    color: primaryColor,
    percentage: 35,
  ),
];
