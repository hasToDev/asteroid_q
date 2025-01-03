import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GameBottomPanel extends StatelessWidget {
  const GameBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Builder(builder: (context) {
          if (width < 550) return const SizedBox();
          return Row(
            spacing: getBottomPanelSpacing(context),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(),
              const VirtualArrowButton(),
              VirtualActionButton(
                title: 'Shoot',
                backgroundColor: scoreColor,
                padding: getBottomPanelVirtualActionPadding(context),
                onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.shoot),
              ),
              VirtualActionButton(
                title: 'Refuel',
                backgroundColor: fuelColor,
                padding: getBottomPanelVirtualActionPadding(context),
                onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.refuel),
              ),
              VirtualActionButton(
                title: 'Move',
                backgroundColor: gameStatsColor,
                padding: getBottomPanelVirtualActionPadding(context),
                onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.move),
              ),
              Builder(builder: (context) {
                if (width >= 550) return const SizedBox();
                return Column(
                  spacing: getBottomPanelSpacing(context),
                  children: [
                    VirtualActionButton(
                      title: 'Shoot',
                      backgroundColor: scoreColor,
                      onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.shoot),
                    ),
                    VirtualActionButton(
                      title: 'Refuel',
                      backgroundColor: fuelColor,
                      onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.refuel),
                    ),
                    VirtualActionButton(
                      title: 'Move',
                      backgroundColor: gameStatsColor,
                      onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.move),
                    ),
                  ],
                );
              }),
            ],
          );
        }),
        Builder(builder: (context) {
          if (width >= 550) return const SizedBox();
          return Row(
            spacing: getBottomPanelSpacing(context),
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VirtualArrowButton(),
              SizedBox(width: getBottomPanelSpacing(context)),
              SizedBox(width: getBottomPanelSpacing(context)),
              Column(
                spacing: getBottomPanelSpacing(context),
                children: [
                  VirtualActionButton(
                    title: 'Shoot',
                    backgroundColor: scoreColor,
                    onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.shoot),
                  ),
                  VirtualActionButton(
                    title: 'Refuel',
                    backgroundColor: fuelColor,
                    onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.refuel),
                  ),
                  VirtualActionButton(
                    title: 'Move',
                    backgroundColor: gameStatsColor,
                    onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.move),
                  ),
                ],
              ),
            ],
          );
        }),
        SizedBox(height: getBottomPanelBottomPadding(context)),
      ],
    );
  }
}
