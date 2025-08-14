part of '../home.dart';

class _FewshotHistory extends StatefulWidget {
  const _FewshotHistory();

  @override
  _FewshotHistoryState createState() => _FewshotHistoryState();
}

class _FewshotHistoryState extends State<_FewshotHistory> {
  late Future<List<Fewshot>> futureFewshots;
  late Future<List<Fewshot>> futureFewshotsSample;

  bool showTitle = true;
  WritingCardBloc get writingCardBloc => context.read<WritingCardBloc>();
  WorkingCardBloc get workingCardBloc => context.read<WorkingCardBloc>();
  LearningCardBloc get learningCardBloc => context.read<LearningCardBloc>();
  LifeCardBloc get lifeCardBloc => context.read<LifeCardBloc>();

  @override
  void initState() {
    super.initState();
    futureFewshots = locator<FewshotRepository>().getAllFewshot();
    futureFewshotsSample = locator<FewshotRepository>().fewshotSample();
    futureFewshots.then((result) {
      if (result.isEmpty) {
        setState(() {
          showTitle = false;
        });
      }
    });
  }

  Future<void> _onFewshotCardPress(Fewshot fewshot) async {
    await _storeAnswer(fewshot);
    switch (fewshot.type) {
      case "WRITING":
        writingCardBloc.add(writingcardEvent.CardSelectFewshot(cardId: fewshot.cardId));
        await writingCardBloc.stream.firstWhere(
          (state) => state.status == WritingCardStateStatus.loadSuccess,
        );
        // await AppNavigator.push(Routes.writingInfo);
        await Navigator.of(context).pushNamed('/home/writingInfo').then((value) => loadData());
        return;
      case "WORKING":
        workingCardBloc.add(workingcardEvent.CardSelectFewshot(cardId: fewshot.cardId));
        await workingCardBloc.stream.firstWhere(
          (state) => state.status == WorkingCardStateStatus.loadSuccess,
        );
        // await AppNavigator.push(Routes.workingInfo);
        await Navigator.of(context).pushNamed('/home/workingInfo').then((value) => loadData());
        return;
      case "LEARNING":
        learningCardBloc.add(learningcardEvent.CardSelectFewshot(cardId: fewshot.cardId));
        await learningCardBloc.stream.firstWhere(
          (state) => state.status == LearningCardStateStatus.loadSuccess,
        );
        // await AppNavigator.push(Routes.learningInfo);
        await Navigator.of(context).pushNamed('/home/learningInfo').then((value) => loadData());
        return;
      case "LIFE":
        lifeCardBloc.add(lifecardEvent.CardSelectFewshot(cardId: fewshot.cardId));
        await lifeCardBloc.stream.firstWhere(
          (state) => state.status == LifeCardStateStatus.loadSuccess,
        );
        // await AppNavigator.push(Routes.lifeInfo);
        await Navigator.of(context).pushNamed('/home/lifeInfo').then((value) => loadData());
        return;
    }
  }

  Future<void> loadData() async {
    futureFewshots = locator<FewshotRepository>().getAllFewshot();
    setState(() {});
  }

  Future<void> _storeAnswer(Fewshot fewshot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> questionAnswerPair = {
      'question': fewshot.question,
      'answer': fewshot.answer,
    };
    String jsonString = json.encode(questionAnswerPair);
    await prefs.setString("card_app" + fewshot.cardId, jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        if (showTitle) _buildHeader(context) else _buildSampleTitle(context),
        if (showTitle) _buildHistory() else _buildSample(),
      ],
    );
  }

  Widget _buildSampleTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28, 0, 28, 22),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '应用示例',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28, 0, 28, 22),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '历史记录',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return FutureBuilder<List<Fewshot>>(
        future: futureFewshots,
        builder: (context, snapshot) {
          final fewshots = snapshot.data ?? [];
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: fewshots.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final fewshot = fewshots[index];
              return FewshotCard(
                fewshot,
                onPress: () => _onFewshotCardPress(fewshot),
              );
            },
          );
        });
  }

  Widget _buildSample() {
    return FutureBuilder<List<Fewshot>>(
        future: futureFewshotsSample,
        builder: (context, snapshot) {
          final fewshots = snapshot.data ?? [];
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: fewshots.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final fewshot = fewshots[index];
              return FewshotCard(
                fewshot,
                onPress: () => _onFewshotCardPress(fewshot),
              );
            },
          );
        });
  }
}
