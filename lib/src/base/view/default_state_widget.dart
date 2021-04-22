import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_flutter/quick_flutter.dart';

class DefaultStateErrorView extends StatelessWidget {
  final String tipText;
  final VoidCallback? onRefresh;

  const DefaultStateErrorView({Key? key, required this.tipText, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onRefresh,
      child: Text(
        tipText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: const Color(0xFFADADAD),
        ),
      ),
    ));
  }
}

class DefaultStateEmptyView extends StatelessWidget {
  final VoidCallback? onRefresh;

  const DefaultStateEmptyView({Key? key, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onRefresh,
        child: Text(
          '数据为空\n点击重新加载',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFFADADAD),
          ),
        ),
      ),
    );
  }
}

/// 加载中
class DefaultStateBusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.blue,
      ),
    ));
  }
}
