import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app_ui/nti_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class NTIWebViewScreen extends StatefulWidget {
  final String url;

  const NTIWebViewScreen({super.key, required this.url});

  @override
  State<NTIWebViewScreen> createState() => _NTIWebViewScreenState();
}

class _NTIWebViewScreenState extends State<NTIWebViewScreen> {
  late final WebViewController _controller;
  final _title = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    _controller = _initController();
  }

  WebViewController _initController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    var url = widget.url;
    if (Platform.isAndroid && url.endsWith("pdf")) {
      url = "https://docs.google.com/gview?embedded=true&url=$url";
    }
    final controller =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onWebResourceError: (error) {
                debugPrint("Error $error");
              },
              onPageFinished: (result) async {
                debugPrint("Success $result");
                _title.value = (await _controller.getTitle()) ?? "";
              },
            ),
          )
          ..loadRequest(Uri.parse(url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    return controller;
  }

  Future<void> _launchUrl() async {
    final messenger = context.messenger;
    if (!await launchUrl(
      Uri.parse(widget.url),
      mode: LaunchMode.externalApplication,
    )) {
      // ignore: prefer_const_constructors
      messenger?.showErrorSnackbar("Failed to launch url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NTIAppBar(
        centerTitle: false,
        context: context,
        title: ValueListenableBuilder<String>(
          valueListenable: _title,
          builder: (context, value, child) {
            return Text(value);
          },
        ),
        actions: [
          Padding(
            padding: 8.rightPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _launchUrl,
                  child: const Text("Open In Browser"),
                ),
              ],
            ),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
