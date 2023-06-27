import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewViewScreen extends StatefulWidget {


  static String routeName = "/webview_screen";
  String? uri;

  ViewViewScreen({super.key, this.uri});

  @override
  State<ViewViewScreen> createState() => _ViewViewScreenState();
}

class _ViewViewScreenState extends State<ViewViewScreen> {
  late WebViewController controller;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.uri ??  'https://www.freeprivacypolicy.com/live/cd5f84f6-f750-4ce3-8572-cf5d56b18679'));
//https://www.freeprivacypolicy.com/live/cd5f84f6-f750-4ce3-8572-cf5d56b18679
//'https://www.freeprivacypolicy.com/live/7e4e776c-732f-435a-8843-4a487911611f'
    setState(() {
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title:  Text(widget.uri != null ? AppLocalizations.of(context)!.terms_use :  AppLocalizations.of(context)!.policy,style:const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'avater'),),backgroundColor: Colors.white,),
      body: loading ?Center(child: CircularProgressIndicator(),):WebViewWidget(controller: controller),
    );
  }
}
