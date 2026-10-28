import 'package:flutter/material.dart';

class NTIBottomNavigation extends StatefulWidget {
  final Color? unselectedItemColor;
  final Color? selectedItemColor;
  final List<BotNavItem> botNavItems;
  const NTIBottomNavigation({
    super.key,
    this.unselectedItemColor,
    this.selectedItemColor,
    required this.botNavItems,
  });

  @override
  State<NTIBottomNavigation> createState() => _NTIBottomNavigationState();
}

class _NTIBottomNavigationState extends State<NTIBottomNavigation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: widget.unselectedItemColor ?? Colors.black,
      selectedItemColor: widget.selectedItemColor ?? Colors.amber,
      showUnselectedLabels: true,
      items:
          widget.botNavItems
              .map(
                (e) => BottomNavigationBarItem(
                  label: e.name,
                  icon: e.icon,
                  activeIcon: e.activeIcon,
                ),
              )
              .toList(),
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.botNavItems[index].onTap?.call();
      },
    );
  }
}

class BotNavItem {
  final String name;
  final Widget icon;
  final Widget activeIcon;
  final void Function()? onTap;
  const BotNavItem({
    required this.name,
    required this.icon,
    required this.activeIcon,
    this.onTap,
  });
}
