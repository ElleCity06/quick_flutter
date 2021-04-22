/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  late String message;
  late String code;

  NotSuccessException(this.message, this.code);

  @override
  String toString() {
    return message;
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => '您的应用未授权';
}

class NoNetWorkException implements Exception {
  const NoNetWorkException();

  @override
  String toString() {
    return '无网络连接,请检查设置';
  }
}
