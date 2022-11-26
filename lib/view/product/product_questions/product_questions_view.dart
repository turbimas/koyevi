import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/product_detail_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/user_question_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_searchbar_view.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/product/product_questions/product_questions_view_model.dart';

class ProductQuestionsView extends ConsumerStatefulWidget {
  final ProductDetailModel product;
  final ProductOverViewModel productOverViewModel;
  const ProductQuestionsView(
      {Key? key, required this.product, required this.productOverViewModel})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductQuestionsViewState();
}

class _ProductQuestionsViewState extends ConsumerState<ProductQuestionsView> {
  late final ChangeNotifierProvider<ProductQuestionsViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => ProductQuestionsViewModel(
        product: widget.product,
        productOverViewModel: widget.productOverViewModel));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getQuestions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar.activeBack(
              LocaleKeys.ProductQuestions_appbar_title.tr(
                  args: [widget.product.name])),
          body: Stack(
            children: [
              _body(),
              Positioned(
                bottom: 15.smh,
                right: 15.smw,
                child: _fab(),
              )
            ],
          )),
    );
  }

  Widget _body() {
    return ref.watch(provider).isLoading
        ? _loading()
        : ref.watch(provider).questions == null
            ? TryAgain(callBack: ref.read(provider).getQuestions)
            : ref.watch(provider).questions!.isEmpty
                ? _empty()
                : _content();
  }

  Widget _loading() => Center(child: CustomImages.loading);

  Widget _empty() {
    return Center(child: _totalQuestions());
  }

  Widget _content() {
    return Column(
      children: [
        _totalQuestions(),
        Divider(thickness: 1, color: CustomColors.primary),
        _searchBar(),
        SizedBox(height: 30.smh),
        ...[..._questions(), SizedBox(height: 70.smh)],
      ],
    );
  }

  Widget _totalQuestions() {
    return Container(
      height: 125.smh,
      width: AppConstants.designWidth.smw,
      margin: EdgeInsets.symmetric(vertical: 10.smh),
      child: Center(
          child: CustomTextLocale(
        LocaleKeys.ProductQuestions_question_count,
        args: [ref.watch(provider).filteredQuestions.length.toString()],
        style: CustomFonts.bodyText2(CustomColors.backgroundText),
      )),
    );
  }

  Widget _searchBar() {
    return CustomSearchBarView(
        onChanged: ref.read(provider).onChanged,
        hint: LocaleKeys.ProductQuestions_search_hint.tr());
  }

  List<Widget> _questions() {
    return ref
        .watch(provider)
        .filteredQuestions
        .map((e) => _questionCard(e))
        .toList();
  }

  Widget _questionCard(UserQuestionModel question) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.primary),
          borderRadius: CustomThemeData.fullRounded),
      width: 340.smw,
      constraints: BoxConstraints(minHeight: 200.smh),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              AuthService.userImage(height: 25.smh, width: 25.smh),
              SizedBox(width: 10.smw),
              CustomText(AuthService.currentUser!.nameSurname,
                  style: CustomFonts.bodyText4(CustomColors.backgroundText))
            ]),
            CustomText(question.date.toString(),
                style: CustomFonts.bodyText4(CustomColors.backgroundText))
          ]),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.smh),
            decoration: BoxDecoration(
                color: CustomColors.card,
                borderRadius: CustomThemeData.fullRounded),
            padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 5.smh),
            width: 320.smw,
            constraints: BoxConstraints(minHeight: 50.smh),
            child: CustomText(question.contentValue,
                maxLines: 20,
                style: CustomFonts.bodyText4(CustomColors.cardText)),
          ),
          SizedBox(height: 10.smh),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CustomIcons.answer_icon,
              SizedBox(width: 10.smw),
              CustomTextLocale(LocaleKeys.ProductQuestions_seller_response,
                  style: CustomFonts.bodyText4(CustomColors.backgroundText))
            ]),
            CustomText(question.date.toString(),
                style: CustomFonts.bodyText4(CustomColors.backgroundText))
          ]),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.smh),
            decoration: BoxDecoration(
                color: CustomColors.card,
                borderRadius: CustomThemeData.fullRounded),
            padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 5.smh),
            width: 320.smw,
            constraints: BoxConstraints(minHeight: 50.smh),
            child: CustomText(question.answer!.contentValue,
                maxLines: 20,
                style: CustomFonts.bodyText4(CustomColors.cardText)),
          )
        ],
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton.extended(
      onPressed: ref.read(provider).addQuestion,
      backgroundColor: Colors.transparent,
      elevation: 0,
      label: Container(
        decoration: BoxDecoration(
            borderRadius: CustomThemeData.fullRounded,
            color: CustomColors.primary),
        height: 50.smh,
        padding: EdgeInsets.symmetric(horizontal: 15.smw),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIcons.add_radiused_icon,
            SizedBox(width: 10.smw),
            CustomTextLocale(LocaleKeys.ProductQuestions_ask_question,
                style: CustomFonts.bodyText4(CustomColors.primaryText))
          ],
        ),
      ),
    );
  }
}
