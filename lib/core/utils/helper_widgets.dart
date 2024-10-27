import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo/core/utils/extensions.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

showNonDismissibleLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return SpinKitThreeBounce(
        color: context.colorScheme.tertiary,
      );
    },
  );
}

Widget shimmerWidget({
  required BuildContext context,
  double? height,
  double? width,
  double borderRadius = 0,
  Color? baseColor,
  Color? highlightColor,
  BoxShape? shape,
}) {
  return Shimmer.fromColors(
    period: const Duration(seconds: 2),
    baseColor: Colors.grey.shade500.withOpacity(.4),
    highlightColor: Colors.white.withOpacity(.3),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: shape != null ? null : BorderRadius.circular(borderRadius),
        shape: shape ?? BoxShape.rectangle,
      ),
    ),
  );
}
