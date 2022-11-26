import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';

class UserCardDetailView extends ConsumerStatefulWidget {
  const UserCardDetailView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserCardDetailViewState();
}

class _UserCardDetailViewState extends ConsumerState<UserCardDetailView> {
  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      appBar: CustomAppBar.activeBack("Kart ekle / düzenle"),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.smh, horizontal: 15.smw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.smh,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check_box, color: CustomColors.primary),
                    SizedBox(width: 5.smw),
                    const Text("Aktif")
                  ],
                ),
              ),
              SizedBox(height: 20.smh),
              _customTextField(hint: "Kart Adı"),
              _customTextField(hint: "Kart Üzerindeki İsim - Soyisim"),
              _customTextField(hint: "Kart Numarası", isInt: true),
              Row(children: [
                _customTextField(hint: "CVV", isInt: true, isHalf: true),
                SizedBox(width: 10.smw),
                _customTextField(
                    hint: "Son Kullanma Tarihi", isInt: true, isHalf: true),
              ]),
            ],
          ),
        ),
        OkCancelPrompt(okCallBack: () {}, cancelCallBack: () {})
      ]),
    ));
  }

  Widget _customTextField(
      {required String hint, bool isInt = false, bool isHalf = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.smh),
      padding: EdgeInsets.symmetric(horizontal: 20.smw),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: CustomColors.primary),
      width: isHalf ? 160.smw : 330.smw,
      height: 50.smh,
      child: Center(
        child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(color: Colors.white),
            keyboardType: isInt ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
                isCollapsed: true,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none)),
      ),
    );
  }
}
