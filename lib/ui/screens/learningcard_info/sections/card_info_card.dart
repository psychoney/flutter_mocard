part of '../learningcard_info.dart';

class _CardInfoCard extends StatefulWidget {
  static const double minCardHeightFraction = 0.54;

  const _CardInfoCard();

  @override
  State<_CardInfoCard> createState() => _CardInfoCardState();
}

class _CardInfoCardState extends State<_CardInfoCard> {
  AnimationController get slideController =>
      LearningCardInfoStateProvider.of(context).slideController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeArea = MediaQuery.of(context).padding;
    final appBarHeight = AppBar().preferredSize.height;

    final cardMinHeight = screenHeight * _CardInfoCard.minCardHeightFraction;
    final cardMaxHeight = screenHeight - appBarHeight - safeArea.top;

    return AutoSlideUpPanel(
      minHeight: cardMinHeight,
      maxHeight: cardMaxHeight,
      onPanelSlide: (position) => slideController.value = position,
      child: CurrentCardSelector((card) {
        return MainTabView(
          paddingAnimation: slideController,
          tabs: [
            MainTabData(
              label: '应用',
              child: CardApp(card: card),
            ),
            MainTabData(
              label: '聊天',
              child: CardChat(card: card),
            ),
          ],
        );
      }),
    );
  }
}
