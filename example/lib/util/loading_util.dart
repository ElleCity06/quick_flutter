import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingUtil {
  static void showLoading({msg = "加载中..."}) {
    EasyLoading.show(
      status: msg,
    );
  }

  static void dismissLoading() {
    EasyLoading.dismiss();
  }

  static void success(String msg) {
    EasyLoading.showSuccess(msg);
  }

  static void showToast(String msg) {
    EasyLoading.showToast(msg);
  }
}
