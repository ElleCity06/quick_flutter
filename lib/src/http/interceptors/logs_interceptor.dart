import 'dart:convert';

import '../../../quick_flutter.dart';


///@date:  2021/2/25 14:22
///@author:  lixu
///@description: 日志拦截器
class LogsInterceptors extends InterceptorsWrapper {
  String _tag = 'HttpLog';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogUtil.v(_tag, "****************onRequest() start*******************");
    LogUtil.v(_tag, 'url：${_getUrl(options)}');
    LogUtil.v(_tag, 'headers: ${json.encode(options.headers)}');
    LogUtil.v(_tag, 'method: ${options.method}');
    LogUtil.v(_tag, 'responseType: ${options.responseType.toString()}');
    LogUtil.v(_tag, 'followRedirects: ${options.followRedirects}');
    LogUtil.v(_tag, 'connectTimeout: ${options.connectTimeout}');
    LogUtil.v(_tag, 'receiveTimeout: ${options.receiveTimeout}');
    LogUtil.v(_tag, 'extra: ${json.encode(options.extra)}');
    LogUtil.v(_tag, 'queryParameters: ${json.encode(options.queryParameters)}');
    LogUtil.v(_tag, 'params: ${json.encode(options.data ?? {})}');
    LogUtil.v(_tag, "****************onRequest() end*********************");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogUtil.v(_tag, "****************onResponse() start******************");
    _printResponse(response);
    LogUtil.v(_tag, "****************onResponse() end********************");
    super.onResponse(response, handler);
  }

  void _printResponse(Response response) {
    LogUtil.v(_tag, 'url: ${_getUrl(response.requestOptions)}');
    LogUtil.v(_tag, 'statusCode: ${response.statusCode}');
    if (response.isRedirect == true) {
      LogUtil.v(_tag, 'redirect: ${response.realUri}');
    }
    LogUtil.v(_tag, 'response headers: ${response.headers.toString()}');
    LogUtil.v(_tag, 'Response Text: ${response.toString()}');
  }

  String _getUrl(RequestOptions requestOptions) {
    String path = requestOptions.path;
    if (!path.startsWith("http")) {
      return requestOptions.baseUrl + path;
    } else {
      return path;
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    LogUtil.v(_tag, "****************onError() start*********************");
    LogUtil.v(_tag, '请求异常: ${err.toString()}');
    LogUtil.v(_tag, '请求异常信息: ${err.response?.toString()}');
    LogUtil.v(_tag, "****************onError() end***********************");
    super.onError(err, handler);
  }
}
