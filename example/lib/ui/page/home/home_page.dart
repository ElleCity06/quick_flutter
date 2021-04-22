import 'dart:io';
import 'dart:math';

import 'package:example/config/impl/http_config_impl.dart';
import 'package:example/model/wx_article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_flutter/quick_flutter.dart';

import 'home_view_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initStatusBar();
    _initBaseLib();
  }

  void _initBaseLib() async {
    await QuickFlutter.init(iHttpConfig: HttpConfigImpl());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "赠人玫瑰手有余刺刺",
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: _getRandomColor(),
      ),
      body: BaseView<HomeViewModel>(
        model: HomeViewModel(),
        // child:_buildContent(),
        child: _buildContent(),
        onModelReady: (model) {
          // var token = model.getToken();
          model.initData();
        },
        onRefresh: (model) {
          // context.read<HomeViewModel>().toUserListPage(context);
          model.getWxArticleList();
        },
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<HomeViewModel>(
      builder: (context1, value, child) => Container(
        margin: EdgeInsets.only(bottom: 16.0),
        child: ListView.builder(
          itemBuilder: (context, index) => _buildItem(
              Provider.of<HomeViewModel>(context1).wxArticleModels[index]),
          itemCount:
              Provider.of<HomeViewModel>(context1).wxArticleModels.length,
        ),
      ),
    );
  }

  _buildItem(WxArticleModel item) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
      decoration: BoxDecoration(
        color: _getRandomColor(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          item.name,
          style: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ),
    );
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      120,
      Random.secure().nextInt(200),
      Random.secure().nextInt(200),
      Random.secure().nextInt(200),
    );
  }

  void _initStatusBar() {
    if (Platform.isAndroid) {
      // 设置系统的沉浸式UI效果--把状态栏变成透明
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark);
      // 应用这个效果
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
