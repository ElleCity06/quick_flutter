class WxArticleModel {
  List<WxArticleModel>? children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  WxArticleModel.fromJsonMap(Map<String, dynamic> map)
      : children = List<WxArticleModel>.from(
            map["children"].map((it) => WxArticleModel.fromJsonMap(it))),
        courseId = map["courseId"],
        id = map["id"],
        name = map["name"] ??= "--",
        order = map["order"],
        parentChapterId = map["parentChapterId"],
        userControlSetTop = map["userControlSetTop"],
        visible = map["visible"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['courseId'] = courseId;
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['parentChapterId'] = parentChapterId;
    data['userControlSetTop'] = userControlSetTop;
    data['visible'] = visible;
    return data;
  }
}
