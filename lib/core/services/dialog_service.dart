import 'dart:typed_data';
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
                  insetPadding: EdgeInsets.all(getDialogInsetPaddingSize(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ConstrainedBox(
                    constraints: getGameOverDialogConstraints(context),
                    child: Padding(
                      padding: EdgeInsets.all(getDialogPaddingSize(context)),
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
                          SizedBox(height: getDialogPaddingSize(context)),
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
                  insetPadding: EdgeInsets.all(getDialogInsetPaddingSize(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ConstrainedBox(
                    constraints: getGameOverDialogConstraints(context),
                    child: Padding(
                      padding: EdgeInsets.all(getDialogPaddingSize(context)),
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
                            'You won the game!',
                            textAlign: TextAlign.center,
                            style: getGameOverStyle(context),
                          ),
                          SizedBox(height: getDialogPaddingSize(context)),
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

  Future<bool?> confirmation({
    required BuildContext context,
    required ConfirmationDialog type,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: semiTransparentColor,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) => Builder(
        builder: (context) {
          double sizeBoxHeight = 0;
          String leftButtonTitle = 'Cancel';
          String rightButtonTitle = 'Exit';
          String description = 'Are you sure ?';
          Uint8List imageByte = getIt<AssetByteService>().imageEXIT!;
          if (type == ConfirmationDialog.signOut) {
            sizeBoxHeight = 16;
            rightButtonTitle = 'Sign Out';
            imageByte = getIt<AssetByteService>().imageSIGNOUT!;
          }
          if (type == ConfirmationDialog.continueGame) {
            sizeBoxHeight = 16;
            description = 'Continue previous game ?';
            leftButtonTitle = 'Start New';
            rightButtonTitle = 'Yes';
            imageByte = getIt<AssetByteService>().imageCONTINUE!;
          }

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: Shadow.convertRadiusToSigma(3),
                  sigmaY: Shadow.convertRadiusToSigma(3),
                ),
                child: Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: EdgeInsets.all(getDialogInsetPaddingSize(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ConstrainedBox(
                    constraints: getGameOverDialogConstraints(context),
                    child: Padding(
                      padding: EdgeInsets.all(getDialogPaddingSize(context)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.memory(
                            imageByte,
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                            isAntiAlias: true,
                          ),
                          SizedBox(height: sizeBoxHeight),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: getGameOverStyle(context),
                          ),
                          SizedBox(height: getDialogPaddingSize(context)),
                          Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppElevatedButton(
                                title: leftButtonTitle,
                                onPressed: () => Navigator.pop(context),
                              ),
                              AppElevatedButton(
                                title: rightButtonTitle,
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

  Future<void> notification({
    required BuildContext context,
    required NotificationDialog type,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: semiTransparentColor,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) => Builder(
        builder: (context) {
          double sizeBoxHeight = 0;
          String title = 'Game Update';
          String description = 'please Refresh page or Clear browser cache';
          if (type == NotificationDialog.newVersion) {
            sizeBoxHeight = 16;
          }
          if (type == NotificationDialog.maintenanceMode) {
            sizeBoxHeight = 16;
            title = 'Game Maintenance';
            description = 'please come back later to play';
          }

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: Shadow.convertRadiusToSigma(3),
                  sigmaY: Shadow.convertRadiusToSigma(3),
                ),
                child: Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: EdgeInsets.all(getDialogInsetPaddingSize(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ConstrainedBox(
                    constraints: getGameOverDialogConstraints(context),
                    child: Padding(
                      padding: EdgeInsets.all(getDialogPaddingSize(context)),
                      child: Builder(builder: (context) {
                        if (constraints.maxHeight < 160) return const SizedBox();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Builder(builder: (context) {
                              if (constraints.maxHeight < 365) {
                                return Image.memory(
                                  getIt<AssetByteService>().imageUPDATE!,
                                  fit: BoxFit.contain,
                                  height: constraints.maxHeight - 160,
                                  width: constraints.maxHeight - 160,
                                  gaplessPlayback: true,
                                  isAntiAlias: true,
                                );
                              }

                              return Image.memory(
                                getIt<AssetByteService>().imageUPDATE!,
                                fit: BoxFit.contain,
                                gaplessPlayback: true,
                                isAntiAlias: true,
                              );
                            }),
                            SizedBox(height: sizeBoxHeight),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: getNotificationStyle(context),
                            ),
                            SizedBox(height: getDialogPaddingSize(context)),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: getGameOverStyle(context),
                            ),
                          ],
                        );
                      }),
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
