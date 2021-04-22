import 'package:example/util/loading_util.dart';
import 'package:quick_flutter/quick_flutter.dart';

class ToastConfigImpl extends IToastConfig {
  @override
  showToast(String text) {
    LoadingUtil.showToast(text);
  }
}
