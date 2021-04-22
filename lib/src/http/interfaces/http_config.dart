import 'dart:io';
import '../../../quick_flutter.dart';

/// http配置
abstract class IHttpConfig {
  ///配置默认值：http请求时是否显示加载dialog
  bool isShowLoading() => false;

  ///配置默认值：http加载提示文本
  String configLoadingText() => "加载中...";

  ///配置默认值：加载中能否通过关闭加载弹窗取消请求
  bool isCancelableDialog() => false;

  ///配置默认值：请求失败时是否自动显示toast提示错误
  bool isShowFailToast() => false;

  ///配置默认值：请求前是否校验网络连接
  ///true：如果无网络，直接返回错误
  bool isCheckNetwork() => true;

  ///配置通用的http请求选项[BaseOptions]
  ///优先级最低，优先取[Api]#[request]方法中配置的method和option
  BaseOptions configBaseOptions();

  /// 配置http请求成功的条件 参考 [DefaultHttpConfigImpl]
  /// [data] 请求的元数据
  bool configHttpResultIsSuccess(Map<String, dynamic> data);

  /// 配置错误的描述信息
  String configHttpResultErrorMessage(Map<String, dynamic> data);

  /// 配置错误code
  String configHttpResultErrorCode(Map<String, dynamic> data);

  // bool configHttpResultIsSuccess(Map<String,dynamic> data);

  ///配置https,默认为true,表示不检验证书,
  bool configHttps(X509Certificate cert, String host, int port) => true;

  ///添加拦截器
  /// 公共请求头可以使用拦截器添加
  ///拦截器队列的执行顺序是FIFO，先添加的拦截器先执行
  List<Interceptor>? configInterceptors() => null;

  ///是否自动添加[LogInterceptors]默认日志拦截器,打印http请求响应相关的日志
  bool configLogEnable() => true;

  ///如果url中不包含baseUrl，请求前回调该方法获取baseUrl
  ///优先级高于[IHttpConfig]#[configBaseOptions]方法配置的baseUrl
  ///[url] 当前正在请求的接口url
  ///return: 返回null使用[IHttpConfig]#[configBaseOptions]方法配置的baseUrl
  String? getBaseUrl(String url);

  ///http请求失败时会回调该方法，判断是否是token失效导致的错误
  ///[errorBean] 请求失败对象
  bool isHttpRespTokenError(Map<String, dynamic> data) => false;

  ///token失效回调该方法
  ///[errorBean] 请求失败对象
  void onTokenErrorCallback();

  ///http请求显示加载框：[Api]#[request]方法isShowLoading字段为true时，会回调该方法 <br/>
  ///[url] 当前请求url<br/>
  ///[tag] 当前请求对应的tag，唯一<br/>
  ///[cancelToken] 用于加载框关闭时取消http请求<br/>
  ///[loadingText] 加载提示提示<br/>
  ///[isCancelableDialog] 请求过程中能否关闭加载框,默认false<br/>
  /// #desc: 不提供默认的loading ,flutter 的dialog 需要context，而quick则不会保留context。
  void showLoading(String url, int tag, CancelToken cancelToken,
      String loadingText, bool isCancelableDialog);

  ///请求完成，关闭加载框：[Api]#[request]方法isShowLoading字段为true时，会回调该方法
  ///[url] 当前请求url
  ///[tag]当前请求对应的tag，唯一
  ///[isCancelled]当前请求是否已经取消，如果已经取消则不用关闭dialog
  void hideLoading(String url, int tag, bool isCancelled);
}

/// 默认的http配置,
class DefaultHttpConfigImpl extends IHttpConfig {
  static const httpTimeOut = 10 * 1000;
  static const String baseUrl = "https://wv.widevision.com.cn/";

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
  String configHttpResultErrorCode(Map<String, dynamic> data) {
    return data['code'].toString();
  }

  @override
  String configHttpResultErrorMessage(Map<String, dynamic> data) {
    return data['message'].toString();
  }

  @override
  bool configHttpResultIsSuccess(Map<String, dynamic> data) {
    return data['code'].toString() == "0";
  }

  @override
  bool isShowFailToast() {
    return true;
  }

  @override
  String? getBaseUrl(String url) {
    return baseUrl;
  }

  @override
  void hideLoading(String url, int tag, bool isCancelled) {}

  @override
  void onTokenErrorCallback() {}

  @override
  void showLoading(String url, int tag, CancelToken cancelToken,
      String loadingText, bool isCancelableDialog) {
    LogUtil.d("sdadada", "显示loading");
  }
}
