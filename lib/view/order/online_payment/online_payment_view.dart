import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnlinePaymentView extends ConsumerStatefulWidget {
  final String initialUrl;
  const OnlinePaymentView({super.key, required this.initialUrl});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnlinePaymentViewState();
}

class _OnlinePaymentViewState extends ConsumerState<OnlinePaymentView> {
  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: CustomAppBar.activeBack("Online Ödeme", showBasket: false),
        body: Center(
          child: WebView(
            initialUrl: widget.initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) {
              log("url: $url");
              if (url.contains("Failed")) {
                Navigator.of(context).pop(false);
              } else if (url.contains("Completed")) {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ),
      ),
    );
  }
}
