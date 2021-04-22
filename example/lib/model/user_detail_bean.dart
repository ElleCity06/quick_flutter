
class UserDetailBean {
  ///头像
  String? icon;

  ///用户id
  String? userId;

  ///用户名
  String? name;

  UserDetailBean.fromJsonMap(Map<String, dynamic> map)
      : userId = map["userId"]?.toString(),
        name = map["name"],
        icon = map["icon"];
}
