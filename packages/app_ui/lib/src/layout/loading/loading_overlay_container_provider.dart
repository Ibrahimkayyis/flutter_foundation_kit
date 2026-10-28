part of 'loading.dart';

class NTILoadingScope extends InheritedWidget {
  final ValueChanged<bool> toggleLoading;
  const NTILoadingScope({
    super.key,
    required super.child,
    required this.toggleLoading,
  });

  static NTILoadingScope of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<NTILoadingScope>();
    if (widget == null) {
      throw Exception("Cant Found Color Provider in the tree");
    }
    return widget;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

extension LoadingScopeExt on BuildContext {
  NTILoadingScope get loadingScope => NTILoadingScope.of(this);
  set loading(bool value) {
    loadingScope.toggleLoading(value);
  }
}
