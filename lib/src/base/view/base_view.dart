import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_flutter/quick_flutter.dart';
import 'package:quick_flutter/src/base/view/default_state_widget.dart';
import 'package:quick_flutter/src/base/view/view_state.dart';
import 'package:quick_flutter/src/base/view_model/base_view_model.dart';

/// @author zavier
/// @time 2021/4/15 10:42
/// @des view 封装类

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  // final ValueWidgetBuilder<T> builder;
  final T model;

  final Widget child;
// final
  final Widget? busyWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Function(T model)? onModelReady;
  final Function(T model)? onRefresh;
  final bool autoDispose;

  BaseView({
    Key? key,
    required this.model,
    required this.child,
    this.onModelReady,
    this.autoDispose = true,
    this.busyWidget,
    this.emptyWidget,
    this.errorWidget,
    this.onRefresh,
  }) : super(key: key);

  @override
  _BaseViewState createState() {
    return _BaseViewState<T>();
  }
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: (context, model1, child) {
          // var  = widget.builder.call(context,model,child);
          if (widget.model.isBusy) {
            return _getBusyWidget();
          }
          if (widget.model.isEmpty) {
            return _getEmptyWidget();
          }
          if (widget.model.isError) {
            return _getErrorWidget(widget.model.viewStateError!.errorType,
                widget.model.viewStateError!.message);
          }
          return widget.child;
        },
        // child: widget.child,
      ),
    );
  }

  Widget _getErrorWidget(ViewStateErrorType errorType, String? errorMsg) {
    return (widget.errorWidget != null
        ? widget.errorWidget
        : QuickFlutter.stateViewConfig.configLoadErrorView(
            errorType,
            errorMsg,
            widget.onRefresh == null
                ? null
                : () {
                    widget.onRefresh!(model);
                  }))!;
  }

  Widget _getEmptyWidget() {
    return (widget.emptyWidget != null
        ? widget.emptyWidget
        : QuickFlutter.stateViewConfig
            .configLoadEmptyView(widget.onRefresh == null
                ? null
                : () {
                    widget.onRefresh!(model);
                  }))!;
  }

  Widget _getBusyWidget() {
    return (widget.busyWidget != null
        ? widget.busyWidget
        : QuickFlutter.stateViewConfig.configBusyView())!;
  }
}
