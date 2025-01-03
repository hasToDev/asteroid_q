import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class VirtualActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  const VirtualActionButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: backgroundColor, width: 2),
            boxShadow: const [
              BoxShadow(
                color: buttonBlackShadow,
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: getStatsStyle(context),
            ),
          ),
        ),
      ),
    );
  }
}
