import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KayitOnBilgilendirmeFormu extends StatefulWidget {
  const KayitOnBilgilendirmeFormu({super.key});

  @override
  State<KayitOnBilgilendirmeFormu> createState() =>
      _KayitOnBilgilendirmeFormuState();
}

class _KayitOnBilgilendirmeFormuState extends State<KayitOnBilgilendirmeFormu> {
  bool isLoading = true;
  String? htmlData;

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      appBar: CustomAppBar.activeBack(
          LocaleKeys.KayitOnBilgilendirmeFormu_appbar_title.tr()),
      body: Center(
          child: isLoading
              ? CustomImages.loading
              : htmlData != null
                  ? WebView(
                      initialUrl: "about:blank",
                      onWebViewCreated: (controller) {
                        controller.loadHtmlString(htmlData!);
                      },
                    )
                  : TryAgain(callBack: _load)),
    ));
  }

  void _load() {
    setState(() {
      isLoading = true;
    });
    NetworkService.get(
      "users/KayitOnBilgilendirmeFormu",
    ).then((value) {
      if (value.success) {
        htmlData = value.data;
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
