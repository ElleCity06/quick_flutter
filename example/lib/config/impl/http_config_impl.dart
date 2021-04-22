import 'package:example/util/loading_util.dart';
import 'package:quick_flutter/quick_flutter.dart';

class HttpConfigImpl extends IHttpConfig {
  static const int httpTimeOut = 10 * 1000;
  static const String baseUrl = "https://wanandroid.com/";

  @override
  BaseOptions configBaseOptions() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: httpTimeOut,
      receiveTimeout: httpTimeOut,
      sendTimeout: httpTimeOut,
      contentType: Http.contentTypeJson,
      method: Http.methodPost,
      responseType: ResponseType.json,
    );
    return options;
  }

  @override
  bool isShowLoading() {
    return true;
  }

  @override
  String configHttpResultErrorCode(Map<String, dynamic> data) {
    return data['errorCode'].toString();
  }

  @override
  String configHttpResultErrorMessage(Map<String, dynamic> data) {
    return data['errorMsg'].toString();
  }

  @override
  bool configHttpResultIsSuccess(Map<String, dynamic> data) {
    return data['errorCode'].toString() == '0';
  }

  @override
  String? getBaseUrl(String url) => baseUrl;

  @override
  void hideLoading(String url, int tag, bool isCancelled) {
    LoadingUtil.dismissLoading();
  }

  @override
  bool isHttpRespTokenError(Map<String, dynamic> data) {
    return data['errorCode'].toString() == "401";
  }

  @override
  void onTokenErrorCallback() {
    // TODO token过期了自定义处理,
    ToastUtil.showDebug("Token过期了");
  }

  @override
  void showLoading(String url, int tag, CancelToken cancelToken,
      String loadingText, bool isCancelableDialog) {
    ///显示http加载dialog：isShowLoading为true时，会回调该方法
    LoadingUtil.showLoading(msg: loadingText);
  }
}
