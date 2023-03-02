import 'package:flutter/material.dart';

class MinTextButton extends TextButton {
  final OutlinedBorder? shape;
  MinTextButton({
    Key? key,
    super.onPressed,
    required super.child,
    this.shape,
    // get all the other parameters for TextButton as well
  }) : super(
          key: key,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
            // fixedSize: Size(width * (isDaily ? 0.55 : 0.45), 50),
            shape: shape ??
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
          ),
        );
}
