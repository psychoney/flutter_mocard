part of '../learning.dart';

class _LearningGrid extends StatefulWidget {
  const _LearningGrid();

  @override
  _LearningGridState createState() => _LearningGridState();
}

class _LearningGridState extends State<_LearningGrid> {
  static const double _endReachedThreshold = 200;

  final GlobalKey<NestedScrollViewState> _scrollKey = GlobalKey();

  LearningCardBloc get cardBloc => context.read<LearningCardBloc>();

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

    return cardBloc.stream.firstWhere((e) => e.status != LearningCardStateStatus.loading);
  }

  void _oncardPress(mocard.Card card) {
    cardBloc.add(CardSelectChanged(cardId: card.id));

    AppNavigator.push(Routes.learningInfo, card);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      key: _scrollKey,
      headerSliverBuilder: (_, __) => [
        MainSliverAppBar(
          title: '学习',
          context: context,
        ),
      ],
      body: CardStateStatusSelector((status) {
        switch (status) {
          case LearningCardStateStatus.loading:
            return _buildLoading();

          case LearningCardStateStatus.loadSuccess:
          case LearningCardStateStatus.loadMoreSuccess:
          case LearningCardStateStatus.loadingMore:
            return _buildGrid();

          case LearningCardStateStatus.loadFailure:
          case LearningCardStateStatus.loadMoreFailure:
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
