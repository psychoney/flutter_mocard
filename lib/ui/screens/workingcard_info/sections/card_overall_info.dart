part of '../workingcard_info.dart';

class _CardOverallInfo extends StatefulWidget {
  const _CardOverallInfo();

  @override
  _CardOverallInfoState createState() => _CardOverallInfoState();
}

class _CardOverallInfoState extends State<_CardOverallInfo> with TickerProviderStateMixin {
  static const double _cardSliderViewportFraction = 0.56;
  static const int _endReachedThreshold = 4;

  final GlobalKey _currentTextKey = GlobalKey();
  final GlobalKey _targetTextKey = GlobalKey();

  double textDiffLeft = 0.0;
  double textDiffTop = 0.0;
  late PageController _pageController;
  late AnimationController _horizontalSlideController;

  WorkingCardBloc get cardBloc => context.read<WorkingCardBloc>();
  AnimationController get slideController =>
      WorkingCardInfoStateProvider.of(context).slideController;
  AnimationController get rotateController =>
      WorkingCardInfoStateProvider.of(context).rotateController;

  Animation<double> get textFadeAnimation => Tween(begin: 1.0, end: 0.0).animate(slideController);
  Animation<double> get sliderFadeAnimation => Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: slideController,
        curve: Interval(0.0, 0.5, curve: Curves.ease),
      ));

  @override
  void initState() {
    _horizontalSlideController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 300),
    )..forward();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final pageIndex = cardBloc.state.selectedCardIndex;

    _pageController = PageController(
      viewportFraction: _cardSliderViewportFraction,
      initialPage: pageIndex,
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _horizontalSlideController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  void _calculateCardNamePosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetTextBox = _targetTextKey.currentContext?.findRenderObject() as RenderBox?;
      final currentTextBox = _currentTextKey.currentContext?.findRenderObject() as RenderBox?;

      if (targetTextBox == null || currentTextBox == null) return;

      final targetTextPosition = targetTextBox.localToGlobal(Offset.zero);
      final currentTextPosition = currentTextBox.localToGlobal(Offset.zero);

      final newDiffLeft = targetTextPosition.dx - currentTextPosition.dx;
      final newDiffTop = targetTextPosition.dy - currentTextPosition.dy;

      if (newDiffLeft != textDiffLeft || newDiffTop != textDiffTop) {
        setState(() {
          textDiffLeft = newDiffLeft;
          textDiffTop = newDiffTop;
        });
      }
    });
  }

  void _onSelectedCardChanged(int index) {
    final cards = cardBloc.state.cards;
    final selectedCard = cards[index];

    cardBloc.add(CardSelectChanged(cardId: selectedCard.id));

    // final shouldLoadMore = index >= cards.length - _endReachedThreshold;

    // // if (shouldLoadMore) {
    // //   cardBloc.add(CardLoadMoreStarted());
    // // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildAppBar(),
        SizedBox(height: 9),
        _buildCardName(),
        SizedBox(height: 9),
        SizedBox(height: 25),
        _buildCardSlider(),
      ],
    );
  }

  AppBar _buildAppBar() {
    return MainAppBar(
      // A placeholder for easily calculate the translate of the card name
      title: CurrentCardSelector((card) {
        _calculateCardNamePosition();

        return Text(
          card.title,
          key: _targetTextKey,
          style: TextStyle(
            color: Colors.transparent,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        );
      }),
      rightIcon: Icons.settings,
    );
  }

  Widget _buildCardName() {
    var bgColor = Theme.of(context).colorScheme.background;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: slideController,
            builder: (_, __) {
              final value = slideController.value;

              return Transform.translate(
                offset: Offset(textDiffLeft * value, textDiffTop * value),
                child: CurrentCardSelector((card) {
                  return HeroText(
                    card.title,
                    textKey: _currentTextKey,
                    style: TextStyle(
                      color: bgColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 36 - (36 - 22) * value,
                    ),
                  );
                }),
              );
            },
          ),
          AnimatedSlide(
            animation: _horizontalSlideController,
            child: AnimatedFade(
              animation: textFadeAnimation,
              child: CurrentCardSelector((card) {
                return HeroText(
                  card.id,
                  style: TextStyle(
                    color: bgColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSlider() {
    final screenSize = MediaQuery.of(context).size;
    final sliderHeight = screenSize.height * 0.24;
    final pokeballSize = screenSize.height * 0.24;
    final cardSize = screenSize.height * 0.3;

    return AnimatedFade(
      animation: sliderFadeAnimation,
      child: SizedBox(
        width: screenSize.width,
        height: sliderHeight,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: RotationTransition(
                turns: rotateController,
                child: Image(
                  image: AppImages.pokeball,
                  width: pokeballSize,
                  height: pokeballSize,
                  color: Colors.white12,
                ),
              ),
            ),
            NumberOfCardsSelector((numberOfCards) {
              return PageView.builder(
                allowImplicitScrolling: true,
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: numberOfCards,
                onPageChanged: _onSelectedCardChanged,
                itemBuilder: (_, index) {
                  return CardSelector(index, (card, selected) {
                    return CardImage(
                      card: card,
                      size: Size.square(cardSize),
                      padding: EdgeInsets.symmetric(
                        vertical: selected ? 0 : screenSize.height * 0.04,
                      ),
                      tintColor: selected ? null : Colors.black26,
                      useHero: selected,
                    );
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
