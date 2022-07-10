import 'package:flutter/material.dart';
import 'package:msm_client/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WiFiView extends StatefulWidget {
  final CookieManager? cookieManager;
  const WiFiView({Key? key, this.cookieManager}) : super(key: key);

  @override
  State<WiFiView> createState() => _WiFiViewState();
}

class _WiFiViewState extends State<WiFiView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Setup'),
      ),
      body: WebView(
        /// TODO: temporary
        /// initialUrl: Globals.webviewUrl,
        initialUrl: 'https://www.google.com',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
        onPageFinished: (String url) {
          /// TODO: temporary
          /// if (url.contains('connect')) {
          if (url.contains('search')) {
            _parseAndPop(url);
          }
        }
      )
    );
  }

  void _parseAndPop(String url) async {
    /// TODO: temporary
    /// Globals.rasp = await _controller.runJavascriptReturningResult(
    ///     "document.getElementById('serial1').innerHTML");  // r
    /// Globals.app = await _controller.runJavascriptReturningResult(
    ///     "document.getElementById('serial2').innerHTML");  // f
    Globals.rasp = 'r';
    Globals.app = 'f';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('rasp', Globals.rasp);
    prefs.setString('app', Globals.app);

    if (!mounted) {
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
