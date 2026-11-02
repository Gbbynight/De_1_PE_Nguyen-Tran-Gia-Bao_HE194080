
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/work.dart';
import '../data/work_database.dart';

part 'work_viewmodel.g.dart';

@riverpod
class WorkViewModel extends _$WorkViewModel {


  @override
  Future<List<Work>> build() async {
    return WorkDatabase.getWorks();
  }


  Future<void> refreshWorks() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => WorkDatabase.getWorks(),
    );
  }


  Future<void> updateWork(Work work) async {
    await WorkDatabase.updateWork(work);
    await refreshWorks();
  }
}


