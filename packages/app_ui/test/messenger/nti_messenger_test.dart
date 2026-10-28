import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_ui/nti_ui.dart';
import 'package:app_ui/test_helper.dart';

void main() {
  Future<Key> renderMessengerWidget(
    WidgetTester tester,
    Function(AppMessenger) onPressed,
  ) async {
    final buttonKey = Key(DateTime.now().toIso8601String());
    await tester.pumpWidget(
      TestHelper.buildTestableWidget(
        Scaffold(
          body: AppMessengerProvider(
            child: Builder(
              builder: (context) {
                return FloatingActionButton(
                  key: buttonKey,
                  onPressed: () => onPressed(AppMessenger.of(context)),
                );
              },
            ),
          ),
        ),
      ),
    );

    return buttonKey;
  }

  group('Dialog Message', () {
    testWidgets('General Dialog', (tester) async {
      const message = 'Hello';
      const title = 'Title';
      const icon = AppIcons.IPL;
      final key = await renderMessengerWidget(tester, (messenger) {
        messenger.showDialogMessage(message: message, title: title, icon: icon);
      });

      await tester.tap(find.byKey(key));

      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      final iconWidget = find.byType(AppIcon);
      expect(iconWidget, findsOneWidget);
      expect(
        iconWidget.evaluate().single.widget,
        isA<AppIcon>().having((icon) => icon.icon, "Icon Data", icon),
      );

      final dialogOverlay = find.byType(NTIDialogContainer);
      await tester.tap(dialogOverlay);

      await tester.pumpAndSettle();

      expect(find.text(message), findsNothing);
      expect(find.text(title), findsNothing);
      expect(find.byType(AppIcon), findsNothing);
    });

    testWidgets('Dialog Sucess', (tester) async {
      const message = 'Hello';
      const title = 'Title';
      const icon = AppIcons.checkCircle;
      final key = await renderMessengerWidget(tester, (messenger) {
        messenger.showSuccessDialog(message: message, title: title);
      });

      await tester.tap(find.byKey(key));

      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      final iconWidget = find.byType(AppIcon);
      expect(iconWidget, findsOneWidget);
      expect(
        iconWidget.evaluate().single.widget,
        isA<AppIcon>().having((icon) => icon.icon, "Icon Data", icon),
      );

      final dialogOverlay = find.byType(NTIDialogContainer);
      await tester.tap(dialogOverlay);

      await tester.pumpAndSettle();

      expect(find.text(message), findsNothing);
      expect(find.text(title), findsNothing);
    });

    testWidgets('Dialog Error', (tester) async {
      const message = 'Hello';
      const title = 'Title';
      const icon = AppIcons.closeCircle;
      final key = await renderMessengerWidget(tester, (messenger) {
        messenger.showErrorDialog(message: message, title: title);
      });

      await tester.tap(find.byKey(key));

      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      final iconWidget = find.byType(AppIcon);
      expect(iconWidget, findsOneWidget);
      expect(
        iconWidget.evaluate().single.widget,
        isA<AppIcon>().having((icon) => icon.icon, "Icon Data", icon),
      );

      final dialogOverlay = find.byType(NTIDialogContainer);
      await tester.tap(dialogOverlay);

      await tester.pumpAndSettle();

      expect(find.text(message), findsNothing);
      expect(find.text(title), findsNothing);
    });
  });

  group('Snackbar Message', () {
    testWidgets('General Snackbar', (tester) async {
      const message = 'Hello';
      const backgroundColor = Colors.red;
      const textColor = Colors.white;
      const iconData = AppIcons.checkCircle;
      final key = await renderMessengerWidget(tester, (messenger) {
        messenger.showSnackbar(
          message: message,
          backgroundColor: (_) => backgroundColor,
          duration: const Duration(seconds: 1),
          textColor: (context) => textColor,
          icon: iconData,
        );
      });

      await tester.tap(find.byKey(key));

      await tester.pump();

      // Check Snackbar
      final snackbar = find.byType(SnackBar);
      expect(snackbar, findsOneWidget);
      final snackbarWidget = (snackbar.evaluate().single.widget as SnackBar);
      expect(snackbarWidget.backgroundColor, backgroundColor);

      // Check Text
      final text = find.text(message);
      expect(text, findsOneWidget);
      final textWidget = text.evaluate().single.widget as Text;
      expect(textWidget.style?.color, textColor);

      // Check Icon
      final icon = find.byType(AppIcon);
      expect(icon, findsOneWidget);
      final iconWidget = icon.evaluate().single.widget as AppIcon;
      expect(iconWidget.icon, iconData);
    });

    testWidgets('Snackbar Success', (tester) async {
      const message = 'Hello';
      final key = await renderMessengerWidget(tester, (messenger) {
        messenger.showSuccessSnackbar(message);
      });

      await tester.tap(find.byKey(key));

      await tester.pump();

      // Check Snackbar
      final snackbar = find.byType(SnackBar);
      expect(snackbar, findsOneWidget);
      final snackbarElement = snackbar.evaluate().single;
      final snackbarWidget = (snackbarElement.widget as SnackBar);
      expect(
        snackbarWidget.backgroundColor,
        (snackbarElement).colorTheme.basic9Reverse,
      );

      // Check Text
      final text = find.text(message);
      expect(text, findsOneWidget);
      final textElement = text.evaluate().single;
      final textWidget = textElement.widget as Text;
      expect(textWidget.style?.color, textElement.colorTheme.basic2Reverse);

      // Check Icon
      final icon = find.byType(AppIcon);
      expect(icon, findsOneWidget);
      final iconElement = icon.evaluate().single;
      final iconWidget = iconElement.widget as AppIcon;
      expect(iconWidget.icon, AppIcons.checkCircle);
      expect(iconWidget.color, iconElement.colorTheme.basic2Reverse);
    });

    testWidgets('Snackbar Error', (tester) async {
      const message = 'Hello';
      final key = await renderMessengerWidget(tester, (messenger) {
        messenger.showErrorSnackbar(message);
      });

      await tester.tap(find.byKey(key));

      await tester.pump();

      // Check Snackbar
      final snackbar = find.byType(SnackBar);
      expect(snackbar, findsOneWidget);
      final snackbarElement = snackbar.evaluate().single;
      final snackbarWidget = (snackbarElement.widget as SnackBar);
      expect(
        snackbarWidget.backgroundColor,
        (snackbarElement).colorTheme.systemDanger,
      );

      // Check Text
      final text = find.text(message);
      expect(text, findsOneWidget);
      final textElement = text.evaluate().single;
      final textWidget = textElement.widget as Text;
      expect(textWidget.style?.color, textElement.colorTheme.basic1Reverse);

      // Check Icon
      final icon = find.byType(AppIcon);
      expect(icon, findsNothing);
    });
  });
}
