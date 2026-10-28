import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';

class NTITab extends StatefulWidget {
  final TabController? controller;
  const NTITab({super.key, this.rounded, required this.tabs, this.controller});

  final List<Tab> tabs;

  final bool? rounded;

  static const routeName = '/Rukun-Tabss';

  @override
  State<NTITab> createState() => _NTITabState();
}

class _NTITabState extends State<NTITab> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Color get _selectedColor => context.colorTheme.primary12Reverse;
  Color get _unselectedColor => context.colorTheme.basic1Reverse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController =
          widget.controller ??
          DefaultTabController.maybeOf(context) ??
          TabController(length: widget.tabs.length, vsync: this);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) {
      _tabController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) return const SizedBox();
    return widget.rounded != null
        ? Container(
          height: kToolbarHeight - 8.0,
          decoration: BoxDecoration(
            color: _unselectedColor,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: _selectedColor,
            ),
            labelColor: Colors.white,
            indicatorPadding: const EdgeInsets.all(8),
            unselectedLabelColor: const Color(0xffBFBFBF),
            tabs: widget.tabs,
          ),
        )
        : Container(
          decoration: BoxDecoration(color: _unselectedColor),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: _selectedColor, width: 3.0),
                left: BorderSide(color: _unselectedColor),
                right: BorderSide(color: _unselectedColor),
              ),
            ),
            tabs: widget.tabs,
            labelColor: Colors.black,
            indicatorColor: _selectedColor,
            unselectedLabelColor: const Color(0xffBFBFBF),
          ),
        );
  }
}
