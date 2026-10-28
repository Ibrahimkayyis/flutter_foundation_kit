import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/style/typography/typhograhpy_example.dart';

class TestHelper {
  static Widget buildTestableWidget(
    Widget widget, {
    RouterConfig<Object>? router,
  }) {
    return ColorThemeProvider(
      initialTheme: colorExample,
      child:
          router == null
              ? MaterialApp(
                builder: (context, child) {
                  return TyphographyProvider(
                    typhographyData: typhoGraphy(context),
                    child: child ?? const SizedBox(),
                  );
                },
                home: widget,
              )
              : MaterialApp.router(
                routerConfig: router,
                builder: (context, child) {
                  return TyphographyProvider(
                    typhographyData: typhoGraphy(context),
                    child: child ?? widget,
                  );
                },
              ),
    );
  }
}
