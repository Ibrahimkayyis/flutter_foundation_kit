part of 'app_messenger.dart';

class AppMessengerHandler {
  static Future<void> handle(BuildContext context, MessengerEvent event) async {
    switch (event) {
      case MessengerSnackbar():
        await handleSnackbar(context, event);
      case MessengerDialog():
        await handleDialog(context, event);
    }
  }

  static Future<void> handleDialog(
    BuildContext context,
    MessengerDialog event,
  ) async {
    final title = event.title;
    final titleStyle = event.titleStyle;
    final icon = event.iconData;
    final message = event.message;
    final textData = TyphographyScope.of(context).textData;
    await showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder:
          (dialogContext) => TyphographyProvider(
            typhographyData: textData,
            child: _DialogMessage(
              title: title,
              iconColor: event.iconColor,
              titleStyle: titleStyle,
              icon: icon,
              message: message,
            ),
          ),
    );
  }

  static Future<void> handleSnackbar(
    BuildContext context,
    MessengerSnackbar state,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: state.duration,
        content: Row(
          children: [
            Expanded(
              child: Text(
                state.message,
                style: context.text.base.copyWith(
                  fontWeight: FontWeight.w500,
                  color: state.textColor(context),
                ),
              ),
            ),
            if (state.iconData != null)
              AppIcon(state.iconData!, color: state.textColor(context)),
          ],
        ),
        backgroundColor: state.backgroundColor(context),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _DialogMessage extends StatelessWidget {
  const _DialogMessage({
    required this.title,
    required this.titleStyle,
    required this.icon,
    required this.message,
    required this.iconColor,
  });

  final String? title;
  final BuildWithContext<TextStyle>? titleStyle;
  final BuildWithContext<Color>? iconColor;
  final AppIcons? icon;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final titleStyle = this.titleStyle;
    final icon = this.icon;
    final message = this.message;
    final iconColor = this.iconColor;
    return GestureDetector(
      onTap: Navigator.of(context).maybePop,
      child: NTIDialogContainer(
        hasDefaultHeader: true,
        builder:
            (header) => SingleChildScrollView(
              child: Column(
                children: [
                  if (title != null)
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: titleStyle?.call(context) ?? context.text.lg.bold,
                    ),
                  if (icon != null)
                    Padding(
                      padding: 16.topPadding,
                      child: AppIcon(
                        icon,
                        height: 56,
                        color: iconColor?.call(context),
                      ),
                    ),
                  if (message != null)
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style:
                          titleStyle?.call(context) ??
                          context.text.base.applyColor(
                            context.colorTheme.basic8Reverse,
                          ),
                    ),
                ],
              ),
            ),
      ),
    );
  }
}
