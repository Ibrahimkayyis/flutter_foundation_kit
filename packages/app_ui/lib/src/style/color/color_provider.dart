part of 'color_theme.dart';

class ColorThemeProvider extends StatefulWidget {
  final ColorTheme initialTheme;
  final Widget child;
  const ColorThemeProvider({
    super.key,
    required this.initialTheme,
    required this.child,
  });

  @override
  State<ColorThemeProvider> createState() => _ColorThemeProviderState();
}

class _ColorThemeProviderState extends State<ColorThemeProvider> {
  late ColorTheme _currentTheme;

  @override
  void initState() {
    _currentTheme = widget.initialTheme;
    super.initState();
  }

  void _changeCurrentTheme(ColorTheme colorTheme) {
    setState(() {
      _currentTheme = colorTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorScope(
      colorTheme: _currentTheme,
      changeCurrentColor: _changeCurrentTheme,
      child: widget.child,
    );
  }
}

class ColorScope extends InheritedWidget {
  final ColorTheme colorTheme;
  final void Function(ColorTheme) changeCurrentColor;
  const ColorScope({
    super.key,
    required this.colorTheme,
    required super.child,
    required this.changeCurrentColor,
  });

  static ColorScope of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ColorScope>();
    if (widget == null) {
      throw Exception("Cant Found Color Provider in the tree");
    }
    return widget;
  }

  @override
  bool updateShouldNotify(ColorScope oldWidget) {
    return oldWidget.colorTheme != colorTheme;
  }
}

extension CtxThemeExt on BuildContext {
  ColorScope get colorScope => ColorScope.of(this);

  ColorTheme get colorTheme => ColorScope.of(this).colorTheme;
}
