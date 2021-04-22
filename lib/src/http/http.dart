import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:quick_flutter/quick_flutter.dart';
import 'package:quick_flutter/src/config/config.dart';
import 'package:quick_flutter/src/config/default_toast_config_impl.dart';
import 'package:quick_flutter/src/http/interceptors/logs_interceptor.dart';

class Http {
  static const _tag = 'Http';
  static const contentTypeJson = Headers.jsonContentType;
  static const contentTypeForm = Headers.formUrlEncodedContentType;
  static const methodPost = "POST";
  static const methodGet = "GET";
  static late IHttpConfig? _httpConfig = DefaultHttpConfigImpl();
  static late IToastConfig _iToastConfig = DefaultToastConfigImpl();

  static Http _instance = Http._();
  static late Dio _dio = Dio();
  List<CancelToken> _cancelTokenList = [];
  static const downLoadReceiveTimeout = 60 * 1000;
  static bool _isAddLog = false;

  Http._();

  factory Http() {
    return _instance;
  }

  /// <h3>初始化</h3>
  /// <p> [iHttpConfig] http配置 </p>
  static void init(IHttpConfig iHttpConfig, {IToastConfig? iToasConfig}) {
    _httpConfig = iHttpConfig;
    if (_iToastConfig != null) {
      _iToastConfig = _iToastConfig;
    }
    _dio = Dio(_httpConfig?.configBaseOptions());

    /// 添加拦截器 ,执行的顺序是 FIFO
    if (_httpConfig?.configInterceptors() != null) {
      _dio.interceptors.addAll(_httpConfig!.configInterceptors()!);
    }

    /// 添加日志拦截器
    if (_httpConfig!.configLogEnable()) {
      _dio.interceptors.add(LogsInterceptors());
      _isAddLog = true;
    }

    /// 配置https
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return _httpConfig!.configHttps(cert, host, port);
      };
    };
  }

  /// <h3>下载文件</h3>
  /// <p>[url] 下载地址 </p>
  /// <p>[savePath] 本地保存的地址</p>
  /// <p>[receiveTimeout] 下载文件超时时间ms</p>
  /// <p>[options] 针对当前请求的配置选项</p>
  /// <p>[onReceiveProgress] 下载进度</p>
  /// <p>return 是否下载成功</p>
  Future<bool> downloadFile(
    String url,
    String savePath, {
    int? receiveTimeout = downLoadReceiveTimeout,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    LogUtil.v(_tag, 'downloadFile() url:$url  savePath:$savePath');
    bool isSuccess;

    ///添加CancelToken,用于取消请求
    cancelToken ??= CancelToken();
    _cancelTokenList.add(cancelToken);

    ///设置超时时间
    if (receiveTimeout != null) {
      options ??= Options();
      options.receiveTimeout = receiveTimeout;
    }

    try {
      await _dio.download(url, savePath,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: options);
      isSuccess = true;
      LogUtil.v(_tag, 'downloadFile() success, url:$url  savePath:$savePath');
    } catch (e) {
      LogUtil.v(_tag, 'downloadFile fail:$e');
      isSuccess = false;
    }

    ///请求完成移除cancelToken
    _cancelTokenList.remove(cancelToken);
    return isSuccess;
  }

  /// <h3>http get请求</h3>
  /// <p>[url] 请求url,如果传入的是一个完整的url,例如 https://xxxx.com/api/getToken,则配置的BaseUrl则会失效</p>
  /// <p>[params] 请求携带的参数</p>
  /// <p>[header] 请求携带的请求头</p>
  /// <p>[option] 针对该次请求的局部配置项，比如超时时间等等 ，具体配置可以看[Options]</p>
  /// <p>[showLoading] 是否显示请求loading ,</p>
  /// <p>[loadingText] loading 的提示文字</p>
  /// <p>[isCancelableDialog] 当前loading是否能够取消，当loading取消则会取消当前请求</p>
  /// <p>[showFailToast] 当请求失败或者出现异常的时候是够提示toast，</p>
  /// <p>[checkNetwork] 请求之前是否先行坚持网络状态</p>
  /// <p>[cancelToken] 取消请求</p>
  /// <p>[onSuccess] 请求成功时候的回调,</p>
  /// <p>[onError] 请求失败的回调</p>
  /// <p>[onComplete] 请求完成时候调用</p>
  ///  /// <p>[onTokenError] token过期时候的特殊处理,不传的时候会回调[IHttpConfig]的 [onTokenErrorCallback]
  Future get(String url,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? header,
      Options? option,
      bool? showLoading,
      String? loadingText,
      bool? isCancelableDialog,
      bool? showFailToast,
      bool? checkNetwork,
      CancelToken? cancelToken,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>?, Exception)? onError,
      Function()? onComplete,
      Function()? onTokenError}) async {
    return _request(url,
        params: params,
        header: header,
        method: methodGet,
        option: option,
        showLoading: showLoading,
        loadingText: loadingText,
        isCancelableDialog: isCancelableDialog,
        showFailToast: showFailToast,
        checkNetwork: checkNetwork,
        cancelToken: cancelToken,
        onSuccess: onSuccess,
        onError: onError,
        onComplete: onComplete,
        onTokenError: onTokenError);
  }

  /// <h3>http Post 请求</h3>
  /// <p>[url] 请求url,如果传入的是一个完整的url,例如 https://xxxx.com/api/getToken,则配置的BaseUrl则会失效</p>
  /// <p>[params] 请求携带的参数</p>
  /// <p>[header] 请求携带的请求头</p>
  /// <p>[option] 针对该次请求的局部配置项，比如超时时间等等 ，具体配置可以看[Options]</p>
  /// <p>[showLoading] 是否显示请求loading ,</p>
  /// <p>[loadingText] loading 的提示文字</p>
  /// <p>[isCancelableDialog] 当前loading是否能够取消，当loading取消则会取消当前请求</p>
  /// <p>[showFailToast] 当请求失败或者出现异常的时候是够提示toast，</p>
  /// <p>[checkNetwork] 请求之前是否先行坚持网络状态</p>
  /// <p>[cancelToken] 取消请求</p>
  /// <p>[onSuccess] 请求成功时候的回调,</p>
  /// <p>[onError] 请求失败的回调</p>
  /// <p>[onComplete] 请求完成时候调用</p>
  ///  /// <p>[onTokenError] token过期时候的特殊处理,不传的时候会回调[IHttpConfig]的 [onTokenErrorCallback]
  Future post(String url,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? header,
      Options? option,
      bool? showLoading,
      String? loadingText,
      bool? isCancelableDialog,
      bool? showFailToast,
      bool? checkNetwork,
      CancelToken? cancelToken,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>?, Exception)? onError,
      Function()? onComplete,
      Function()? onTokenError}) async {
    return _request(url,
        params: params,
        header: header,
        method: methodPost,
        option: option,
        showLoading: showLoading,
        loadingText: loadingText,
        isCancelableDialog: isCancelableDialog,
        showFailToast: showFailToast,
        checkNetwork: checkNetwork,
        cancelToken: cancelToken,
        onSuccess: onSuccess,
        onError: onError,
        onComplete: onComplete,
        onTokenError: onTokenError);
  }

  /// <h3>http通用请求</h3>
  /// <p>[url] 请求url,如果传入的是一个完整的url,例如 https://xxxx.com/api/getToken,则配置的BaseUrl则会失效</p>
  /// <p>[params] 请求携带的参数</p>
  /// <p>[header] 请求携带的请求头</p>
  /// <p>[method] 请求方法，get或者pos</p>
  /// <p>[option] 针对该次请求的局部配置项，比如超时时间等等 ，具体配置可以看[Options]</p>
  /// <p>[showLoading] 是否显示请求loading ,</p>
  /// <p>[loadingText] loading 的提示文字</p>
  /// <p>[isCancelableDialog] 当前loading是否能够取消，当loading取消则会取消当前请求</p>
  /// <p>[showFailToast] 当请求失败或者出现异常的时候是够提示toast，</p>
  /// <p>[checkNetwork] 请求之前是否先行坚持网络状态</p>
  /// <p>[cancelToken] 取消请求</p>
  /// <p>[onSuccess] 请求成功时候的回调,</p>
  /// <p>[onError] 请求失败的回调</p>
  /// <p>[onComplete] 请求完成时候调用</p>
  /// <p>[onTokenError] token过期时候的特殊处理,不传的时候会回调[IHttpConfig]的 [onTokenErrorCallback]
  Future _request(String url,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? header,
      String? method,
      Options? option,
      bool? showLoading,
      String? loadingText,
      bool? isCancelableDialog,
      bool? showFailToast,
      bool? checkNetwork,
      CancelToken? cancelToken,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>?, Exception)? onError,
      Function()? onComplete,
      Function()? onTokenError}) async {
    showLoading ??= _httpConfig!.isShowLoading();
    loadingText ??= _httpConfig!.configLoadingText();
    isCancelableDialog ??= _httpConfig!.isCancelableDialog();
    checkNetwork ??= _httpConfig!.isCheckNetwork();
    showFailToast ??= _httpConfig!.isShowFailToast();

    ///添加CancelToken,用于取消请求
    cancelToken ??= CancelToken();
    _cancelTokenList.add(cancelToken);
    if (QuickFlutter.isDebug && !_isAddLog) {
      _dio.interceptors.add(LogsInterceptors());
      _isAddLog = true;
    }

    /// 请求获取到的数据
    var _data;

    if (checkNetwork) {
      ///判断网络连接
      ConnectivityResult connResult = await Connectivity().checkConnectivity();
      if (connResult == ConnectivityResult.none) {
        return onError?.call(_data, NoNetWorkException());
      }
    }

    ///显示加载框
    if (showLoading) {
      _httpConfig!.showLoading(url, cancelToken.hashCode, cancelToken,
          loadingText, isCancelableDialog);
    }
    option ??= Options();
    params ??= {};

    ///添加baseUrl
    ///baseUrl优先级：形参url>_httpConfig.getBaseUrl>_httpConfig.configBaseOptions
    if (!url.startsWith('http') && !url.startsWith('https')) {
      String? baseUrl = _httpConfig!.getBaseUrl(url);
      if (baseUrl != null && baseUrl.isNotEmpty) {
        url = baseUrl + url;
      }
    }

    ///处理请求头
    if (header != null) {
      option.headers ??= {};
      option.headers!.addAll(header);
    }

    ///设置请求方法
    if (method != null) {
      option.method = method;
    } else {
      option.method ??= _httpConfig!.configBaseOptions().method;
      option.method ??= methodPost;
    }
    try {
      Response _response;
      if (methodGet == option.method) {
        ///get请求
        _response = await _dio.get(url,
            queryParameters: params, options: option, cancelToken: cancelToken);
      } else if (methodPost == option.method) {
        ///默认post请求
        _response = await _dio.post(url,
            data: params, options: option, cancelToken: cancelToken);
      } else {
        ///其他请求方式
        _response = await _dio.request(url,
            data: params, options: option, cancelToken: cancelToken);
      }
      _data = _response.data;
      if (_httpConfig!.configHttpResultIsSuccess(_data)) {
        onSuccess?.call(_data);
      } else if (_httpConfig!.isHttpRespTokenError(_data)) {
        if (onTokenError != null) {
          onTokenError.call();
        } else {
          _httpConfig!.onTokenErrorCallback();
        }

        onError?.call(_data, UnAuthorizedException());
      } else {
        if (showFailToast) {
          _iToastConfig
              .showToast(_httpConfig!.configHttpResultErrorMessage(_data));
        }
        onError?.call(
            _data,
            NotSuccessException(
                _httpConfig!.configHttpResultErrorMessage(_data),
                _httpConfig!.configHttpResultErrorCode(_data)));
      }
    } on DioError catch (e) {
      if (showFailToast && e.type != DioErrorType.cancel) {
        _iToastConfig.showToast(_createErrorString(e));
      }
      onError?.call(_data, e);
    } catch (exception) {
      LogUtil.e(_tag, ' 异常:${exception.toString()}');
      onError?.call(_data, NotSuccessException(exception.toString(), "-1"));
    } finally {
      ///请求完成，隐藏加载框
      if (showLoading) {
        _httpConfig!
            .hideLoading(url, cancelToken.hashCode, cancelToken.isCancelled);
      }

      ///请求完成移除cancelToken
      if (_cancelTokenList.contains(cancelToken)) {
        _cancelTokenList.remove(cancelToken);
      }

      ///请求完成回调
      onComplete?.call();
    }
  }

  ///封装错误bean
  String _createErrorString(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return "请求取消";

      case DioErrorType.connectTimeout:
        return "连接超时";

      case DioErrorType.sendTimeout:
        return "请求超时";

      case DioErrorType.receiveTimeout:
        return "响应超时";

      case DioErrorType.response:
        return error.response?.statusMessage ?? '未知错误';

      default:
        return "unKnow";
    }
  }

  ///取消所有请求
  void cancelAll() {
    LogUtil.v(_tag, 'cancelAll:${_cancelTokenList.length}');
    _cancelTokenList.forEach((cancelToken) {
      cancel(cancelToken);
    });
    _cancelTokenList.clear();
  }

  ///取消指定的请求
  void cancel(CancelToken? cancelToken) {
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  ///取消指定的请求
  void cancelList(List<CancelToken>? cancelTokenList) {
    LogUtil.v(_tag, 'cancelList:${cancelTokenList?.length}');
    cancelTokenList?.forEach((cancelToken) {
      cancel(cancelToken);
    });
  }
}
