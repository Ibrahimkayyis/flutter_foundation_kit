part of 'error_widget.dart';

class _NetworkErrorData {
  final SvgGenImage svg;
  final String Function(BuildContext context) text;
  final String Function(BuildContext context) buttonText;

  const _NetworkErrorData({
    required this.svg,
    required this.text,
    required this.buttonText,
  });
}

class _NetworkError {
  static final _errors = <int, _NetworkErrorData>{
    402: _NetworkErrorData(
      svg: Assets.error.error402Unauthorized,
      buttonText: (context) => context.t.error.network.k402.buttonText,
      text: (context) => context.t.error.network.k402.text,
    ),
    403: _NetworkErrorData(
      svg: Assets.error.error403AccessDenied,
      buttonText: (context) => context.t.error.network.k403.buttonText,
      text: (context) => context.t.error.network.k403.text,
    ),
    404: _NetworkErrorData(
      svg: Assets.error.error404NotFound,
      buttonText: (context) => context.t.error.network.k404.buttonText,
      text: (context) => context.t.error.network.k404.text,
    ),
    408: _NetworkErrorData(
      svg: Assets.error.error408Timeout,
      buttonText: (context) => context.t.error.network.k408.buttonText,
      text: (context) => context.t.error.network.k408.text,
    ),
    413: _NetworkErrorData(
      svg: Assets.error.error403AccessDenied,
      buttonText: (context) => context.t.error.network.k413.buttonText,
      text: (context) => context.t.error.network.k413.text,
    ),
    500: _NetworkErrorData(
      svg: Assets.error.error500,
      buttonText: (context) => context.t.error.network.k500.buttonText,
      text: (context) => context.t.error.network.k500.text,
    ),
    502: _NetworkErrorData(
      svg: Assets.error.error500,
      buttonText: (context) => context.t.error.network.k502.buttonText,
      text: (context) => context.t.error.network.k502.text,
    ),
    503: _NetworkErrorData(
      svg: Assets.error.error503,
      buttonText: (context) => context.t.error.network.k503.buttonText,
      text: (context) => context.t.error.network.k503.text,
    ),
  };

  static const _backCodes = [404, 402, 403];

  static _NetworkErrorData getError(NetworkException exception) {
    final data = _errors[exception.statusCode];
    if (data != null) return data;
    return _NetworkErrorData(
      buttonText: (context) => context.t.error.network.unknown.buttonText,
      svg: Assets.error.errorUnknown,
      text: (context) => context.t.error.network.unknown.text,
    );
  }

  static _ErrorParams toParams(
    NetworkException exception,
    void Function(BuildContext context)? onTryAgain,
  ) {
    final errorData = getError(exception);
    return _ErrorParams(
      errorMessage: errorData.text,
      image: Padding(padding: 16.bottomPadding, child: errorData.svg.svg()),
      button: errorData.buttonText,
      onButtonTap: (context) {
        final shouldGoBack = _backCodes.contains(exception.statusCode);
        if (shouldGoBack) {
          Navigator.of(context).maybePop();
          return;
        }
        onTryAgain?.call(context);
      },
    );
  }
}
