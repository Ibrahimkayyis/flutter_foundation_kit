part of '../dialog_container.dart';

class NTIConfirmationDialog extends StatelessWidget {
  final String? title;
  final String? desc;
  final String? dialogTitle;
  final bool backButton;
  final Widget? descWidget;
  final String? confirmText;
  final String? cancelText;
  final TextAlign? titleAlign;
  final EdgeInsets contentPadding;

  ///When Reverse active the negative action
  ///will be on primary button
  final bool reverseMode;
  const NTIConfirmationDialog({
    super.key,
    this.title,
    this.desc,
    this.confirmText,
    this.titleAlign,
    this.dialogTitle,
    this.backButton = false,
    this.cancelText,
    this.reverseMode = false,
    this.descWidget,
    this.contentPadding = const EdgeInsets.only(top: 4),
  });

  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? desc,
    String? confirmText,
    String? cancelText,
    Widget? descWidget,
    TextAlign? titleAlign,
    String? dialogTitle,
    bool backButton = false,
    EdgeInsets contentPadding = const EdgeInsets.only(top: 4),

    ///When Reverse active the negative action
    ///will be on primary button
    bool reverseMode = false,
  }) async {
    final result = await showDialog(
      context: context,
      useRootNavigator: false,
      builder:
          (context) => NTIConfirmationDialog(
            title: title,
            desc: desc,
            dialogTitle: dialogTitle,
            backButton: backButton,
            titleAlign: titleAlign,
            descWidget: descWidget,
            reverseMode: reverseMode,
            confirmText: confirmText,
            cancelText: cancelText,
            contentPadding: contentPadding,
          ),
    );
    return result is bool && result;
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final color = context.colorTheme;
    return NTIDialogContainer(
      hasExitIcon: true,
      title: dialogTitle,
      onBackPressed: backButton ? () => Navigator.of(context).pop() : null,
      hasDefaultHeader: true,
      builder: (header) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (header != null) header,
              Padding(
                padding: contentPadding,
                child: Column(
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          title!,
                          textAlign: titleAlign,
                          style: text.lg.copyWith(
                            color: color.basic10Reverse,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (desc != null && descWidget == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          desc!,
                          style: text.base.copyWith(height: 1.1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (descWidget != null) descWidget!,
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          AppDefaultButton(
                            text: confirmText ?? context.t.dialog.confirm,
                            isFillParent: true,
                            onPressed:
                                () => Navigator.of(
                                  context,
                                ).pop(reverseMode ? false : true),
                          ),
                          const SizedBox(height: 10),
                          AppOutlinedButton(
                            buttonType: ButtonType.secondary,
                            onPressed:
                                () => Navigator.of(
                                  context,
                                ).pop(reverseMode ? true : false),
                            text: cancelText ?? context.t.dialog.cancel,
                            isFillParent: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
