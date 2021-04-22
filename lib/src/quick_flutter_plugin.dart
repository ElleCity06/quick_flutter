import 'dart:async';

import 'package:quick_flutter/quick_flutter.dart';
import 'package:quick_flutter/src/config/config.dart';
import 'package:quick_flutter/src/config/default_stateview_config_impl.dart';
import 'package:quick_flutter/src/utils/log_util.dart';

class QuickFlutter {
  ///是否是debug模式
  static bool _isDebug = true;

  static bool get isDebug => _isDebug;

  ///缺省布局资源配置
  static late IStateViewConfig _stateViewConfig = DefaultStateViewConfig();

  static IStateViewConfig get stateViewConfig => _stateViewConfig;

  static Future<void> init(
      {bool debug = true,
      LogConfig? logConfig,
      IStateViewConfig? stateViewConfig,IHttpConfig? iHttpConfig,IToastConfig? iToastConfig}) async {
    _isDebug = debug;
    if (stateViewConfig != null) {
      _stateViewConfig = stateViewConfig;
    }
    if (logConfig != null) {
      LogUtil.init(isDebug: debug, tag: logConfig.tag);
    } else {
      LogUtil.init(isDebug: debug);
    }
    if(iHttpConfig!=null){
      Http.init(iHttpConfig);
    }
  }
}
