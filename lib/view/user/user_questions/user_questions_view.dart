import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/models/user/user_question_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/view/user/user_questions/user_questions_view_model.dart';

class UserQuestionsView extends ConsumerStatefulWidget {
  const UserQuestionsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserQuestionsViewState();
}

class _UserQuestionsViewState extends ConsumerState<UserQuestionsView> {
  late final ChangeNotifierProvider<UserQuestionsViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider<UserQuestionsViewModel>(
        ((ref) => UserQuestionsViewModel()));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getQuestions();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar:
            CustomAppBar.activeBack(LocaleKeys.UserQuestions_appbar_title.tr()),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [_filters(), _cards()],
        ),
      ),
    );
  }

  Widget _filters() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.smh),
      height: 60.smh,
      width: 360.smw,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: CustomColors.primary, width: 1),
          bottom: BorderSide(color: CustomColors.primary, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => ref.read(provider).index = 0,
              child: AnimatedContainer(
                duration: CustomThemeData.animationDurationShort,
                curve: Curves.easeInOut,
                color: ref.watch(provider).index == 0
                    ? CustomColors.primary
                    : CustomColors.card,
                child: Center(
                  child: CustomTextLocale(LocaleKeys.UserQuestions_answered,
                      style: CustomFonts.bodyText2(
                          ref.watch(provider).index == 0
                              ? CustomColors.primaryText
                              : CustomColors.cardText)),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => ref.read(provider).index = 1,
              child: AnimatedContainer(
                duration: CustomThemeData.animationDurationShort,
                curve: Curves.easeInOut,
                color: ref.watch(provider).index == 1
                    ? CustomColors.primary
                    : CustomColors.card,
                child: Center(
                  child: CustomTextLocale(LocaleKeys.UserQuestions_unanswered,
                      style: CustomFonts.bodyText2(
                          ref.watch(provider).index == 1
                              ? CustomColors.primaryText
                              : CustomColors.cardText)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cards() {
    if (ref.watch(provider).index == 0 &&
        ref.watch(provider).answered.isEmpty) {
      return Expanded(
          child: Center(
              child: CustomTextLocale(
                  LocaleKeys.UserQuestions_answered_question_not_found,
                  style: CustomFonts.bodyText2(CustomColors.backgroundText))));
    }
    if (ref.watch(provider).index == 1 &&
        ref.watch(provider).unanswered.isEmpty) {
      return Expanded(
          child: Center(
              child: CustomTextLocale(
                  LocaleKeys.UserQuestions_unanswered_question_not_found,
                  style: CustomFonts.bodyText2(CustomColors.backgroundText))));
    }
    return SizedBox(
      height: 670.smh,
      width: 340.smw,
      child: ref.watch(provider).index == 0
          ? ListView.builder(
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              itemCount: ref.watch(provider).answered.length,
              itemBuilder: (context, index) => _answeredCard(index),
            )
          : ListView.builder(
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              itemCount: ref.watch(provider).unanswered.length,
              itemBuilder: (context, index) => _unansweredCard(index),
            ),
    );
  }

  Widget _answeredCard(index) {
    UserQuestionModel questionModel = ref.watch(provider).answered[index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
      margin: EdgeInsets.only(bottom: 10.smh),
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.primary, width: 1.smw),
          borderRadius: CustomThemeData.fullRounded,
          color: CustomColors.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductOverViewHorizontalView(product: questionModel.product),
          SizedBox(height: 15.smh),
          Row(children: [
            AuthService.userImage(height: 25.smh, width: 25.smh),
            SizedBox(width: 10.smw),
            Text(AuthService.currentUser!.nameSurname,
                style: CustomFonts.bodyText3(CustomColors.cardText))
          ]),
          SizedBox(height: 5.smh),
          Text(
            questionModel.contentValue,
            style: CustomFonts.bodyText4(CustomColors.cardText),
          ),
          SizedBox(height: 15.smh),
          Row(children: [
            CustomIcons.answer_icon,
            SizedBox(width: 10.smw),
            CustomTextLocale(LocaleKeys.UserQuestions_seller_answer,
                style: CustomFonts.bodyText3(CustomColors.cardText))
          ]),
          SizedBox(height: 5.smh),
          Text(
            questionModel.answer!.contentValue,
            style: CustomFonts.bodyText4(CustomColors.cardText),
          ),
        ],
      ),
    );
  }

  Widget _unansweredCard(index) {
    UserQuestionModel questionModel = ref.watch(provider).unanswered[index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
      margin: EdgeInsets.only(bottom: 10.smh),
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.primary, width: 1.smw),
          borderRadius: CustomThemeData.fullRounded,
          color: CustomColors.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductOverViewHorizontalView(product: questionModel.product),
          SizedBox(height: 15.smh),
          Row(children: [
            AuthService.userImage(height: 25.smh, width: 25.smh),
            SizedBox(width: 10.smw),
            Text(AuthService.currentUser!.nameSurname,
                style: CustomFonts.bodyText3(CustomColors.cardText))
          ]),
          SizedBox(height: 5.smh),
          Text(
            questionModel.contentValue,
            style: CustomFonts.bodyText4(CustomColors.cardText),
          ),
        ],
      ),
    );
  }
}
