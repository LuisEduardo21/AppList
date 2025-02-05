import 'package:app_list/view_model/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  final T? model;
  final Widget? child;
  final Function(T)? onModelReady;
  final Function(T)? onDispose;
  final Function(T, AppLifecycleState)? didChangeAppLifecycleState;

  const BaseView({
    Key? key,
    this.model,
    required this.builder,
    this.child,
    this.onModelReady,
    this.onDispose,
    this.didChangeAppLifecycleState,
  }) : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>>
    with WidgetsBindingObserver {
  T? model;

  @override
  void initState() {
    model = widget.model;
    if (widget.onModelReady != null) {
      widget.onModelReady!.call(model!);
    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.didChangeAppLifecycleState != null) {
      widget.didChangeAppLifecycleState!.call(model!, state);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!.call(model!);
    }
    model!.mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (BuildContext context) {
        return model!;
      },
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
