part of 'app_messenger.dart';

typedef BuildWithContext<T> = T Function(BuildContext context);

sealed class MessengerEvent extends Equatable {
  const MessengerEvent();

  @override
  List<Object?> get props => [];
}

class MessengerDialog extends MessengerEvent {
  final String? message;

  final String? title;
  final BuildWithContext<TextStyle>? titleStyle;
  final BuildWithContext<Color>? iconColor;
  final AppIcons? iconData;

  const MessengerDialog({
    this.message,
    required this.title,
    this.titleStyle,
    this.iconData,
    this.iconColor,
  });

  @override
  List<Object?> get props => [message, iconData, titleStyle, title, iconColor];
}

class MessengerSnackbar extends MessengerEvent {
  final String message;
  final BuildWithContext<Color> backgroundColor;
  final BuildWithContext<Color> textColor;
  final Duration duration;
  final AppIcons? iconData;

  const MessengerSnackbar({
    required this.message,
    required this.backgroundColor,
    required this.duration,
    this.iconData,
    required this.textColor,
  });

  @override
  List<Object?> get props => [message, iconData];
}
