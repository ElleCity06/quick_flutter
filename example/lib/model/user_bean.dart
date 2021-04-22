
class UserBean {
  String? userId;
  String? name;
  String? nickName;
  List? centerIds;

  UserBean.fromJsonMap(Map<String, dynamic> map)
      : userId = map["userId"]?.toString(),
        name = map["name"],
        centerIds = map["centerIds"],
        nickName = map["nickName"];

  @override
  String toString() {
    return 'UserBean{userId: $userId, name: $name, nickName: $nickName}';
  }
}
