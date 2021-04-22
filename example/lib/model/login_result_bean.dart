import 'user_bean.dart';
class LoginResultBean {
  String? token;
  UserBean? user;

  LoginResultBean.fromJsonMap(Map<String, dynamic> map)
      : token = map['token'],
        user = map['user'] != null ? UserBean.fromJsonMap(map['user']) : null;

  @override
  String toString() {
    return 'LoginResultBean{token: $token, user: $user}';
  }
}
