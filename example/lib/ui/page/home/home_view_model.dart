import 'package:example/model/wx_article_model.dart';
import 'package:quick_flutter/quick_flutter.dart';

class HomeViewModel extends BaseViewModel {
  // List<T> list = [];
  static const String apiWxArticle = '/wxarticle/chapters/json';
  List<WxArticleModel> wxArticleModels = [];

  initData() async {
    setBusy();
    await Future.delayed(Duration(seconds: 2), () {
      setEmpty();
    });
    return null;
  }

  Future<List<WxArticleModel>> getWxArticleList() async {
    await http.get(
      apiWxArticle,
      onSuccess: (data) {
        wxArticleModels = data['data']
            .map<WxArticleModel>((item) => WxArticleModel.fromJsonMap(item))
            .toList();
      },
      onError: (data, e) {
        setError(e);
      },
    );
    setIdle();
    return wxArticleModels;
  }

  Future getToken() async {
    Map<String, dynamic> map = {
      'account': '15015001500',
      'pass': '123qwe',
      'appType': 'PATIENT',
      'device': 'ANDROID',
      'push': '13065ffa4e22e63efd2',
    };
    await http.post(
      "login/user/login",
      params: map,
      loadingText: "获取Token...",
      onSuccess: (data) {
        LogUtil.d("HomeViewModel", data);
      },
      onError: (data, e) {
        // setError(e);
      },
    );
    return null;
  }
// 下拉刷新

}
