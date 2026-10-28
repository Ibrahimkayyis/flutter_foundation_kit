import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';

part 'primary_toggle.dart';
part 'secondary_toggle.dart';

abstract class AppToggle extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool defaultValue;
  final String? enableText;
  final String? disableText;
  final double? width;
  final double? height;
  final double borderRadius;
  final Decoration Function(
    BuildContext context,
    bool isToggle,
    Animation circleAnimation,
  )
  trackDecorationBuilder;
  final Decoration Function(BuildContext context, bool isToggle)
  dotDecorationBuilder;

  const AppToggle({
    super.key,
    required this.defaultValue,
    this.width,
    this.height,
    required this.onChanged,
    this.enableText,
    this.disableText,
    required this.borderRadius,
    required this.trackDecorationBuilder,
    required this.dotDecorationBuilder,
  });

  @override
  State<StatefulWidget> createState() => _AppToggleState();
}

class _AppToggleState extends State<AppToggle>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;
  bool _isToggled = false;

  void _toggleSwitch(bool value) {
    widget.onChanged(value);
    setState(() {
      _isToggled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggled = widget.defaultValue;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _circleAnimation = AlignmentTween(
      begin: _isToggled ? Alignment.centerRight : Alignment.centerLeft,
      end: _isToggled ? Alignment.centerLeft : Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            _toggleSwitch(!_isToggled);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: widget.trackDecorationBuilder(
              context,
              _isToggled,
              _circleAnimation,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 2.0,
                bottom: 2.0,
                right: 2.0,
                left: 2.0,
              ),
              child: Container(
                alignment:
                    _isToggled ? Alignment.centerRight : Alignment.centerLeft,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: widget.dotDecorationBuilder(
                        context,
                        _isToggled,
                      ),
                    ),
                    if (widget.enableText != null && widget.disableText != null)
                      Positioned(
                        right: _isToggled ? 24 : null,
                        left: !_isToggled ? 24 : null,
                        child: Text(
                          _isToggled ? widget.enableText! : widget.disableText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


typedef NTIToggle = AppToggle;
