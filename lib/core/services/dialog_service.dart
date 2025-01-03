import 'dart:ui';

import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DialogService {
  Future<bool?> gameOver({
    required BuildContext context,
    required String description,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: semiTransparentColor,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) => Builder(
        builder: (context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: Shadow.convertRadiusToSigma(3),
                  sigmaY: Shadow.convertRadiusToSigma(3),
                ),
                child: Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430, minWidth: 330),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.memory(
                            getIt<AssetByteService>().imageGAMEOVER!,
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                            isAntiAlias: true,
                          ),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: getGameOverStyle(context),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppElevatedButton(
                                title: 'Retry',
                                onPressed: () => Navigator.pop(context, true),
                              ),
                              AppElevatedButton(
                                title: 'Exit',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> gameWinner({
    required BuildContext context,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: semiTransparentColor,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) => Builder(
        builder: (context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double animationSizeLimit = 382;
              double animationHeight = constraints.maxHeight - (16 * 3) - (24 * 3) - 16 - 14 - 26;
              if (animationHeight >= animationSizeLimit) animationHeight = animationSizeLimit;

              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: Shadow.convertRadiusToSigma(3),
                  sigmaY: Shadow.convertRadiusToSigma(3),
                ),
                child: Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                      minWidth: 330,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.memory(
                            getIt<AssetByteService>().animationWINNER!,
                            fit: BoxFit.contain,
                            height: animationHeight,
                            filterQuality: FilterQuality.medium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Congratulations!',
                            textAlign: TextAlign.center,
                            style: getGameOverStyle(context),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppElevatedButton(
                                title: 'Leaderboard',
                                onPressed: () => Navigator.pop(context, true),
                              ),
                              AppElevatedButton(
                                title: 'Game Menu',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> exitConfirmation({
    required BuildContext context,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: semiTransparentColor,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) => Builder(
        builder: (context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: Shadow.convertRadiusToSigma(3),
                  sigmaY: Shadow.convertRadiusToSigma(3),
                ),
                child: Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430, minWidth: 330),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.memory(
                            getIt<AssetByteService>().imageEXIT!,
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                            isAntiAlias: true,
                          ),
                          Text(
                            'Are you sure ?',
                            textAlign: TextAlign.center,
                            style: getGameOverStyle(context),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppElevatedButton(
                                title: 'Cancel',
                                onPressed: () => Navigator.pop(context),
                              ),
                              AppElevatedButton(
                                title: 'Exit',
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
