import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String? eventUrl;
  final String? eventName;

  const WebView({super.key, this.eventUrl, this.eventName});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(Uri.parse('${widget.eventUrl}'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventName}'),
        iconTheme: IconThemeData(
          color: Colors.blue, // Set the color you want for the back arrow
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Colors.blue, // Set the color for the search icon
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
