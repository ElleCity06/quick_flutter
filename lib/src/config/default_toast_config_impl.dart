import 'package:quick_flutter/quick_flutter.dart';
import 'package:quick_flutter/src/config/config.dart';

class DefaultToastConfigImpl extends IToastConfig {
  @override
  showToast(String text) {
    ToastUtil.show(text);
  }
}
