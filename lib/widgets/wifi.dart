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
        initialUrl: Globals.webviewUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
        onPageFinished: (String url) {
          if (url.contains('connect')) {
            _parseAndPop(url);
          }
        }
      )
    );
  }

  void _parseAndPop(String url) async {
    Globals.rasp = await _controller.runJavascriptReturningResult(
        "document.getElementById('serial1').innerHTML");  // r
    Globals.app = await _controller.runJavascriptReturningResult(
        "document.getElementById('serial2').innerHTML");  // f
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('rasp', Globals.rasp.replaceAll('"', ''));
    prefs.setString('app', Globals.app.replaceAll('"', ''));

    if (!mounted) {
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
