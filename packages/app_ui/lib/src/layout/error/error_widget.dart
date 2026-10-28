import 'package:flutter/material.dart';
import 'package:app_ui/src/buttons/button.dart';
import 'package:app_ui/src/core/disctionaries/translations.g.dart';
import 'package:app_ui/src/ext/index.dart';
import 'package:app_ui/src/gen/assets.gen.dart';
import 'package:app_ui/src/style/styles.dart';
import 'package:app_types/types.dart';

part 'network_error.dart';

typedef ErrorMessageBuilder = String Function(BuildContext context);

class AppErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final ErrorMessageBuilder? errorMessageBuilder;
  final Widget? image;
  final bool isCenter;
  final String? button;
  final ErrorMessageBuilder? buttonBuilder;
  final void Function(BuildContext context)? onButtonTap;
  const AppErrorWidget({
    super.key,
    this.errorMessage,
    this.image,
    this.button,
    this.isCenter = true,
    this.onButtonTap,
    this.errorMessageBuilder,
    this.buttonBuilder,
  });

  AppErrorWidget._fromParams({
    required _ErrorParams params,
    bool isCenter = true,
  }) : this(
         image: params.image,
         onButtonTap: params.onButtonTap,
         isCenter: isCenter,
         errorMessageBuilder: params.errorMessage,
         buttonBuilder: params.button,
       );

  factory AppErrorWidget.fromException(
    BaseException exception, {
    Key? key,
    void Function(BuildContext context)? onTryAgain,
    bool isCenter = true,
  }) {
    if (exception is NetworkException) {
      return AppErrorWidget._fromParams(
        isCenter: isCenter,
        params: _NetworkError.toParams(exception, onTryAgain),
      );
    }
    if (exception is ConnectionException) {
      return AppErrorWidget(
        errorMessage: exception.message,
        onButtonTap: onTryAgain,
        isCenter: isCenter,
        button: "Coba Lagi",
        image: Padding(
          padding: 16.bottomPadding,
          child: Assets.error.errorConnection.svg(),
        ),
      );
    }
    if (exception.isUnknownError) {
      return AppErrorWidget(
        isCenter: isCenter,
        errorMessage: "Mohon maaf terjadi kesalahan, silahkan coba lagi",
        onButtonTap: onTryAgain,
        button: "Coba Lagi",
        image: Padding(
          padding: 16.bottomPadding,
          child: Assets.error.errorUnknown.svg(),
        ),
      );
    }
    return AppErrorWidget(errorMessage: exception.message, isCenter: isCenter);
  }

  Widget _buildContent(BuildContext context, Widget child) {
    if (isCenter) {
      return Center(child: child);
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Padding(
      padding: 16.horizontalPadding,
      child: _buildContent(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) SizedBox(height: 200, width: 200, child: image!),
            const SizedBox(height: 16),
            if (errorMessage != null || errorMessageBuilder != null)
              Text(
                errorMessageBuilder?.call(context) ?? errorMessage!,
                textAlign: TextAlign.center,
                style: text.sm.medium.copyWith(
                  color: context.colorTheme.basic3,
                ),
              ),
            if (button != null || buttonBuilder != null)
              Padding(
                padding: 8.topPadding,
                child: AppOutlinedButton(
                  text: buttonBuilder?.call(context) ?? button!,
                  padding: (18, 8).padding,
                  buttonType: ButtonType.secondary,
                  onPressed: () {
                    onButtonTap?.call(context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorParams {
  final ErrorMessageBuilder errorMessage;
  final Widget? image;
  final ErrorMessageBuilder? button;
  final void Function(BuildContext context)? onButtonTap;

  const _ErrorParams({
    required this.errorMessage,
    required this.image,
    required this.button,
    required this.onButtonTap,
  });
}


typedef NTIErrorWidget = AppErrorWidget;
