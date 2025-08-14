import 'package:mocard/data/source/mappers/fewshotmodel_to_fewshot_mapper.dart';

import '../../domain/entities/fewshot.dart';
import '../../utils/locator.dart';
import '../source/server/server_datasource.dart';

abstract class FewshotRepository {
  Future<List<Fewshot>> getAllFewshot();
  Future<List<Fewshot>> fewshotSample();
}

class FewshotDefaultRepository extends FewshotRepository {
  @override
  Future<List<Fewshot>> getAllFewshot() async {
    final FewshotModels = await locator<ServerDataSource>().fewshotHistory();
    final fewshots = FewshotModels.map((e) => e.toEntity()).toList();
    return fewshots;
  }

  @override
  Future<List<Fewshot>> fewshotSample() async {
    final FewshotModels = await locator<ServerDataSource>().fewshotSample();
    final fewshots = FewshotModels.map((e) => e.toEntity()).toList();
    return fewshots;
  }
}
