part of '../writing.dart';

class _WritingGrid extends StatefulWidget {
  const _WritingGrid();

  @override
  _WritingGridState createState() => _WritingGridState();
}

class _WritingGridState extends State<_WritingGrid> {
  static const double _endReachedThreshold = 200;

  final GlobalKey<NestedScrollViewState> _scrollKey = GlobalKey();

  WritingCardBloc get cardBloc => context.read<WritingCardBloc>();

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      cardBloc.add(CardLoadStarted());
      _scrollKey.currentState?.innerController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _scrollKey.currentState?.innerController.dispose();
    _scrollKey.currentState?.dispose();

    super.dispose();
  }

  void _onScroll() {
    final innerController = _scrollKey.currentState?.innerController;

    if (innerController == null || !innerController.hasClients) return;

    final thresholdReached = innerController.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      // Load more!
      cardBloc.add(CardLoadMoreStarted());
    }
  }

  Future _onRefresh() async {
    cardBloc.add(CardLoadStarted());

    return cardBloc.stream.firstWhere((e) => e.status != WritingCardStateStatus.loading);
  }

  void _oncardPress(mocard.Card card) {
    cardBloc.add(CardSelectChanged(cardId: card.id));

    AppNavigator.push(Routes.writingInfo, card);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      key: _scrollKey,
      headerSliverBuilder: (_, __) => [
        MainSliverAppBar(
          title: '写作',
          context: context,
        ),
      ],
      body: CardStateStatusSelector((status) {
        switch (status) {
          case WritingCardStateStatus.loading:
            return _buildLoading();

          case WritingCardStateStatus.loadSuccess:
          case WritingCardStateStatus.loadMoreSuccess:
          case WritingCardStateStatus.loadingMore:
            return _buildGrid();

          case WritingCardStateStatus.loadFailure:
          case WritingCardStateStatus.loadMoreFailure:
            return _buildError();

          default:
            return Container();
        }
      }),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Image(image: AppImages.pikloader),
    );
  }

  Widget _buildGrid() {
    return CustomScrollView(
      slivers: [
        CardRefreshControl(onRefresh: _onRefresh),
        SliverPadding(
          padding: EdgeInsets.all(28),
          sliver: NumberOfCardsSelector((numberOfcards) {
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  return CardSelector(index, (card, _) {
                    return MoCard(
                      card,
                      onPress: () => _oncardPress(card),
                    );
                  });
                },
                childCount: numberOfcards,
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: CardCanLoadMoreSelector((canLoadMore) {
            if (!canLoadMore) {
              return SizedBox.shrink();
            }

            return Container(
              padding: EdgeInsets.only(bottom: 28),
              alignment: Alignment.center,
              child: Image(image: AppImages.pikloader),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildError() {
    return CustomScrollView(
      slivers: [
        CardRefreshControl(onRefresh: _onRefresh),
        SliverFillRemaining(
          child: Container(
            padding: EdgeInsets.only(bottom: 28),
            alignment: Alignment.center,
            child: Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: Colors.black26,
            ),
          ),
        ),
      ],
    );
  }
}
