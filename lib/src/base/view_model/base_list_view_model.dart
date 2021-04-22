
import 'package:quick_flutter/quick_flutter.dart';
import 'package:quick_flutter/src/base/view_model/base_view_model.dart';

/// @author zavier
/// @time 2021/4/15 10:22
/// @des

abstract class BaseListViewModel<T> extends BaseViewModel {
  List<T> list = [];

  /// 第一次进入页面loading skeleton
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  // 下拉刷新
  refresh({bool init = false}) async {
    try {
      List<T> data = await loadData();
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        setIdle();
      }
    } catch (e, s) {
      if (init) list.clear();
      LogUtil.printErrorStack(e, s);
      setError(e);
    }
  }

  // 加载数据
  Future<List<T>> loadData();

  onCompleted(List<T> data) {}
}
