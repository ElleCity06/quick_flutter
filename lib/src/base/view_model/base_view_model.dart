import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_flutter/quick_flutter.dart';
import 'package:quick_flutter/src/base/view/view_state.dart';
import 'package:quick_flutter/src/http/exception/custom_exception.dart';

class BaseViewModel with ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  /// 充当Model
  late Http http = Http();

  ///保存请求token，用于页面关闭时取消请求
  List<CancelToken> cancelTokenList = [];

  /// 当前的页面状态,默认是idle
  late ViewState _viewState;

  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    // if (value != ViewState.error) {
    //   _viewStateError = null;
    // }
    _viewState = value;
    notifyListeners();
  }

  ViewStateError? _viewStateError;

  ViewStateError? get viewStateError => _viewStateError;

  set viewStateError(ViewStateError? value) {
    _viewStateError = value;
    notifyListeners();
  }

  BaseViewModel({ViewState? viewState})
      : _viewState = viewState ?? ViewState.idle {
    // debugPrint('ViewStateModel---constructor--->$runtimeType');
  }

  bool get isBusy => viewState == ViewState.busy;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  /// set
  void setIdle() {
    viewState = ViewState.idle;
  }

  void setBusy() {
    viewState = ViewState.busy;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  /// [e]分类Error和Exception两种
  void setError(e, {String? message}) {
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;

    /// 见https://github.com/flutterchina/dio/blob/master/README-ZH.md#dioerrortype
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        // timeout
        errorType = ViewStateErrorType.networkTimeOutError;
        message = e.error;
      } else if (e.type == DioErrorType.response) {
        // incorrect status, such as 404, 503...
        message = e.error;
      } else if (e.type == DioErrorType.cancel) {
        message = e.error;
      } else {
        // dio将原error重新套了一层
        e = e.error;
        if (e is UnAuthorizedException) {
          errorType = ViewStateErrorType.unauthorizedError;
        } else if (e is NotSuccessException) {
          message = e.message;
        } else if (e is NoNetWorkException) {
          message = e.toString();
        } else if (e is SocketException) {
          errorType = ViewStateErrorType.networkTimeOutError;
          message = e.message;
        } else {
          message = e.message;
        }
      }
    }
    if (e is UnAuthorizedException) {
      errorType = ViewStateErrorType.unauthorizedError;
    }
    LogUtil.d("addaasda", errorType);
    viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: message ??= "",
      errorMessage: e.toString(),
    );
    onError(viewStateError);
  }

  /// 可以通过重写该方法对错误时候做一些操作,比如token过期的时候自动跳转登录界面
  void onError(ViewStateError? viewStateError) {
    viewState = ViewState.error;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
    http.cancelList(cancelTokenList);
  }
}
