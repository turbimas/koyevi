import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnlinePaymentView extends ConsumerStatefulWidget {
  final String initialUrl;
  final String guid;
  const OnlinePaymentView(
      {super.key, required this.initialUrl, required this.guid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnlinePaymentViewState();
}

class _OnlinePaymentViewState extends ConsumerState<OnlinePaymentView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _checkPayment();
        return Future(() => false);
      },
      child: CustomSafeArea(
        child: Scaffold(
          appBar: CustomAppBar.activeBack(
              LocaleKeys.OnlinePayment_appbar_title.tr(),
              showBasket: false),
          body: Center(
            child: WebView(
              initialUrl: widget.initialUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (url) async {
                if (url.contains("Failed") || url.contains("Completed")) {
                  _checkPayment();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkPayment() async {
    ResponseModelBoolean responseModel =
        await NetworkService.get("orders/ordercheckpayment/${widget.guid}");
    if (responseModel.success) {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
