import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/nti_ui.dart';

part 'event.dart';
part 'handler.dart';

class AppMessengerProvider extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;
  const AppMessengerProvider({
    super.key,
    required this.child,
    this.navigatorKey,
  });

  @override
  State<AppMessengerProvider> createState() => _AppMessengerProviderState();
}

class _AppMessengerProviderState extends State<AppMessengerProvider> {
  void _onMessageReceived(MessengerEvent event) {
    final context = widget.navigatorKey?.currentContext ?? this.context;
    AppMessengerHandler.handle(context, event);
  }

  @override
  Widget build(BuildContext context) {
    return AppMessenger(
      onMessageReceived: _onMessageReceived,
      child: widget.child,
    );
  }
}

class AppMessenger extends InheritedWidget {
  final void Function(MessengerEvent) onMessageReceived;
  const AppMessenger({
    super.key,
    required super.child,
    required this.onMessageReceived,
  });

  static AppMessenger of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<AppMessenger>()!;
  }

  static AppMessenger? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<AppMessenger>();
  }

  void showSuccessSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) {
    showSnackbar(
      message: message,
      backgroundColor: (context) => context.colorTheme.basic9Reverse,
      duration: duration,
      icon: AppIcons.checkCircle,
      textColor: (context) => context.colorTheme.basic2Reverse,
    );
  }

  void showErrorSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) {
    showSnackbar(
      message: message,
      backgroundColor: (context) => context.colorTheme.systemDanger,
      duration: duration,
      textColor: (context) => context.colorTheme.basic1Reverse,
    );
  }

  void showSuccessDialog({String? message, String? title}) {
    showDialogMessage(
      message: message,
      title: title,
      icon: AppIcons.checkCircle,
    );
  }

  void showErrorDialog({String? message, String? title}) {
    showDialogMessage(
      message: message,
      title: title,
      icon: AppIcons.closeCircle,
      iconColor: (context) => context.colorTheme.systemDanger,
    );
  }

  void showDialogMessage({
    String? message,
    String? title,
    AppIcons? icon,
    BuildWithContext<Color>? iconColor,
    BuildWithContext<TextStyle>? titleStyle,
  }) {
    onMessageReceived(
      MessengerDialog(
        title: title,
        titleStyle: titleStyle,
        message: message,
        iconColor:
            iconColor ?? (context) => context.colorTheme.brandTeal10Reverse,
        iconData: icon,
      ),
    );
  }

  void showSnackbar({
    required String message,
    required BuildWithContext<Color> backgroundColor,
    required Duration duration,
    AppIcons? icon,
    required BuildWithContext<Color> textColor,
  }) {
    onMessageReceived(
      MessengerSnackbar(
        message: message,
        backgroundColor: backgroundColor,
        duration: duration,
        iconData: icon,
        textColor: textColor,
      ),
    );
  }

  @override
  bool updateShouldNotify(AppMessenger oldWidget) => false;
}

extension AppMessengerX on BuildContext {
  AppMessenger? get messenger => AppMessenger.maybeOf(this);

  void showSuccessDialog({String? message, String? title}) {
    messenger?.showSuccessDialog(message: message, title: title);
  }

  void showErrorDialog({String? message, String? title}) {
    messenger?.showErrorDialog(message: message, title: title);
  }

  void showSuccessSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) {
    messenger?.showSuccessSnackbar(message, duration: duration);
  }

  void showErrorSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) {
    messenger?.showErrorSnackbar(message, duration: duration);
  }
}


typedef NTIMessengerProvider = AppMessengerProvider;
typedef NTIMessenger = AppMessenger;
typedef NTIMessengerHandler = AppMessengerHandler;
