import 'package:flutter/material.dart';
import 'package:quick_flutter/src/base/view/default_state_widget.dart';
import 'package:quick_flutter/src/base/view/view_state.dart';
import 'package:quick_flutter/src/config/config.dart';

class DefaultStateViewConfig extends IStateViewConfig {
  @override
  Widget? configBusyView() {
    return DefaultStateBusyWidget();
  }

  @override
  Widget? configLoadEmptyView(VoidCallback? onRefresh) {
    return DefaultStateEmptyView(
      onRefresh: onRefresh,
    );
  }

  @override
  Widget? configLoadErrorView(
      ViewStateErrorType errorType, String? errorMsg, VoidCallback? onRefresh) {
    String _tipText = "加载失败 $errorMsg\n点击重新加载";
    if (errorType == ViewStateErrorType.networkTimeOutError) {
      _tipText = "网络连接超时\n点击重新加载";
    } else if (errorType == ViewStateErrorType.unauthorizedError) {
      _tipText = "您还未登录\n点击去登录";
    }
    return DefaultStateErrorView(
      tipText: _tipText,
      onRefresh: onRefresh,
    );
  }
}
