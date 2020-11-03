import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlDialog extends StatefulWidget {
  const HtmlDialog(this.content);

  final String content;

  @override
  HtmlDialogState createState() => HtmlDialogState();
}

class HtmlDialogState extends State<HtmlDialog> {
  double _height = 150;
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: _height,
        child: WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _controller.loadUrl(
              Uri.dataFromString(
                widget.content,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              ).toString(),
            );
          },
          onPageFinished: (some) async {
            final height = await _controller.evaluateJavascript(
              'document.documentElement.scrollHeight;',
            );
            final width = await _controller.evaluateJavascript(
              'document.documentElement.scrollWidth;',
            );

            if (int.tryParse(width) != null) {
              _controller.scrollTo(int.parse(width) ~/ 2, 0);
            }
            if (double.tryParse(height) != null) {
              setState(() => _height = double.parse(height));
            }
          },
          navigationDelegate: (NavigationRequest request) async {
            final uri = Uri.parse(request.url);

            if (['http', 'https', 'data', 'about'].contains(uri.scheme)) {
              if (await canLaunch(request.url)) {
                await launch(request.url);
              }
            }
            return NavigationDecision.prevent;
          },
        ),
      ),
    );
  }
}
