import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class AmplifyAuth extends StatefulWidget {
  const AmplifyAuth({
    super.key,
    required this.state,
    required this.body,
    this.footer,
    this.isSignUp = false,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;
  final bool isSignUp;

  @override
  State<AmplifyAuth> createState() => _AmplifyAuthState();
}

class _AmplifyAuthState extends State<AmplifyAuth> {
  double authenticatorSignInFormHeight = 372;
  double authenticatorSignUpFormHeight = 472;

  double heightLimit = 0;
  double logoHeightLimit = 300;
  double edgePadding = 16;

  @override
  void initState() {
    if (widget.isSignUp) heightLimit = authenticatorSignUpFormHeight;
    if (!widget.isSignUp) heightLimit = authenticatorSignInFormHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool useSingleChildScrollView = false;
    double separatorSize = getLegendItemSeparatorSize(context);
    double availableHeight = size.height - heightLimit - logoHeightLimit - (edgePadding * 2) - separatorSize;
    if (widget.isSignUp) availableHeight = availableHeight - 50;
    if (availableHeight <= 0) useSingleChildScrollView = true;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(edgePadding),
        child: Builder(builder: (context) {
          if (!useSingleChildScrollView) {
            return ListView(
              shrinkWrap: true,
              children: [
                Builder(builder: (context) {
                  if (availableHeight > 0) return SizedBox(height: availableHeight / 2);
                  return const SizedBox();
                }),
                Builder(builder: (context) {
                  double imageSize = logoHeightLimit;
                  if (widget.isSignUp) {
                    imageSize = imageSize - 20;
                  }
                  return Image.memory(
                    getIt<AssetByteService>().appLogo!,
                    fit: BoxFit.contain,
                    height: imageSize,
                    width: imageSize,
                    gaplessPlayback: true,
                    isAntiAlias: true,
                  );
                }),
                SizedBox(height: separatorSize),
                Builder(builder: (context) {
                  double maxWidth = size.width - (edgePadding * 2);
                  if (maxWidth > 400) maxWidth = 400;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: maxWidth, child: widget.body),
                    ],
                  );
                }),
                Builder(builder: (context) {
                  if (availableHeight > 0) return SizedBox(height: availableHeight / 2);
                  return const SizedBox();
                }),
              ],
            );
          }

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Builder(builder: (context) {
                    double imageSize = logoHeightLimit - 50;
                    if (widget.isSignUp) {
                      imageSize = imageSize - 20;
                    }
                    return Image.memory(
                      getIt<AssetByteService>().appLogo!,
                      fit: BoxFit.contain,
                      height: imageSize,
                      width: imageSize,
                      gaplessPlayback: true,
                      isAntiAlias: true,
                    );
                  }),
                  SizedBox(height: separatorSize),
                  Builder(builder: (context) {
                    double maxWidth = size.width - (edgePadding * 2);
                    if (maxWidth > 400) maxWidth = 400;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: maxWidth, child: widget.body),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
      persistentFooterButtons: widget.footer != null ? [widget.footer!] : null,
    );
  }
}
