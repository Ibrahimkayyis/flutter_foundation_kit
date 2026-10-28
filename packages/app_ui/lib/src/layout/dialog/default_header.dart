part of 'dialog_container.dart';

class _DialogDefaultHeader extends StatelessWidget {
  const _DialogDefaultHeader({
    required this.onBackPressed,
    required this.title,
    required this.hasExitIcon,
    this.backIcon,
    this.closeIcon,
    this.onClosePressed,
  });

  final VoidCallback? onBackPressed;
  final VoidCallback? onClosePressed;
  final String? title;
  final bool hasExitIcon;
  final Widget? backIcon;
  final Widget? closeIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: onBackPressed != null,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: InkWell(
            onTap: onBackPressed,
            child: backIcon ?? const _DialogBackIcon(),
          ),
        ),
        Expanded(
          child:
              title != null
                  ? Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: context.text.heading5.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.colorTheme.basic8Reverse,
                    ),
                  )
                  : const SizedBox(),
        ),
        Visibility(
          visible: hasExitIcon || closeIcon != null,
          child: InkWell(
            onTap: onClosePressed ?? () => Navigator.of(context).pop(),
            child: closeIcon ?? const _DialogExitIcon(),
          ),
        ),
      ],
    );
  }
}

class _DialogBackIcon extends StatelessWidget {
  const _DialogBackIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AppIcon(
        AppIcons.arrowLeft,
        width: 21,
        color: context.colorTheme.basic10Reverse,
      ),
    );
  }
}

class _DialogExitIcon extends StatelessWidget {
  const _DialogExitIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colorTheme.basic4Reverse,
      ),
      child: AppIcon(
        AppIcons.close,
        width: 21,
        color: context.colorTheme.basic10Reverse,
      ),
    );
  }
}
