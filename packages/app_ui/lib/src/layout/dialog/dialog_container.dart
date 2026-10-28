import 'package:flutter/material.dart';
import 'package:app_ui/src/buttons/button.dart';
import 'package:app_ui/src/core/disctionaries/translations.g.dart';
import 'package:app_ui/src/icon/nti_icon/icon.dart';
import 'package:app_ui/src/style/styles.dart';

part 'default_header.dart';
part 'default/confirmation_dialog.dart';

class NTIDialogContainer extends StatelessWidget {
  final double maxHeightPercentage;
  final Widget Function(Widget? header) builder;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final bool hasExitIcon;
  final String? title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onClosePressed;
  final bool hasDefaultHeader;
  final BoxDecoration? decoration;
  final Widget? backIcon;
  final Widget? closeIcon;
  final bool resizeToAvoidBottomInset;

  const NTIDialogContainer({
    super.key,
    this.maxHeightPercentage = 0.9,
    this.backgroundColor,
    required this.builder,
    this.hasExitIcon = false,
    this.padding,
    this.resizeToAvoidBottomInset = true,
    this.title,
    this.hasDefaultHeader = false,
    this.onBackPressed,
    this.decoration,
    this.backIcon,
    this.closeIcon,
    this.onClosePressed,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(onTap: () => Navigator.of(context).pop()),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        padding ??
                        EdgeInsets.symmetric(
                          horizontal: size.width * .05,
                          vertical: 0,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: size.height * maxHeightPercentage,
                            minHeight: 0,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color:
                                  backgroundColor ?? colorTheme.basic1Reverse,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  contentPadding ??
                                  const EdgeInsets.symmetric(
                                    vertical: 24,
                                    horizontal: 24,
                                  ),
                              child: builder(
                                hasDefaultHeader
                                    ? _DialogDefaultHeader(
                                      onBackPressed: onBackPressed,
                                      title: title,
                                      backIcon: backIcon,
                                      closeIcon: closeIcon,
                                      onClosePressed: onClosePressed,
                                      hasExitIcon: hasExitIcon,
                                    )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
