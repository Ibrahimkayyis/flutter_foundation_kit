import 'package:flutter/material.dart';

class NTIMenuNavigator extends StatelessWidget {
  const NTIMenuNavigator({
    super.key,
    required this.title,
    this.subtitle,
    this.topText,
    this.menuIcon,
    this.routeName,
  });

  final String? subtitle;
  final String? topText;
  final String title;
  final Widget? menuIcon;
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        routeName != null
            ? Navigator.restorablePushNamed(context, routeName!)
            : false;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            menuIcon ?? const SizedBox(width: 0),
            const SizedBox(width: 8),
            Column(
              children: <Widget>[
                topText != null
                    ? Text(
                      topText!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        color: Color(0xff8C8C8C),
                      ),
                    )
                    : const SizedBox(height: 0),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
