import 'package:flutter/material.dart';
import 'package:quick_flutter/quick_flutter.dart';
import 'package:quick_flutter/src/base/view/view_state.dart';

class LogConfig {
  late String tag;

  LogConfig({required this.tag});
}

abstract class IToastConfig {
  showToast(String text);
}

/// 配置缺省页面
abstract class IStateViewConfig {
  ///配置全局加载中的页面
  Widget? configBusyView();

  ///配置全局加载数据为空的页面
  Widget? configLoadEmptyView(VoidCallback? onRefresh);

  ///配置全局加载失败的页面
  /// [errorType] 错误类型 ,可以根据不同的错误类型去显示相关的用户提示，具体类型可以看 [ViewStateErrorType]
  /// [onRefresh] 点击事件
  Widget? configLoadErrorView(
      ViewStateErrorType errorType, String? errorMsg, VoidCallback? onRefresh);
}

