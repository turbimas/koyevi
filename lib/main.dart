import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koyevi/core/initializations.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/view/auth/splash/splash_view.dart';

// import 'package:uni_links/uni_links.dart';

void main(List<String> args) async {
  initSync();
  await initAsync();

  // StreamSubscription<ServiceStatus> serviceStatusStream =
  //     Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
  //   log(status.toString());
  //   Geolocator.openAppSettings();
  // });
  // linkStream.listen((String? uri) {
  //   log("geldi: $uri");
  // }, onError: (err) {});

  runApp(EasyLocalization(
      supportedLocales: const [AppConstants.EN_LOCALE, AppConstants.TR_LOCALE],
      path: AppConstants.PATH_LOCALE,
      saveLocale: true,
      fallbackLocale: AppConstants.EN_LOCALE,
      useOnlyLangCode: true,
      child: const App()));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeIndexCubit(),
        child: ProviderScope(
            child: ScreenUtilInit(
                designSize: AppConstants.designSize,
                builder: (context, child) => child!,
                child: MaterialApp(
                    title: "koyevi",
                    builder: EasyLoading.init(),
                    darkTheme: ThemeData.light(),
                    debugShowCheckedModeBanner: false,
                    navigatorKey: NavigationService.navigatorKey,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    home: SplashView(setstate: setstateCallback)))));
  }

  void setstateCallback() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }
}
