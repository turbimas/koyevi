import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';

class CustomSearchBarView extends ConsumerStatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final bool autofocus;
  const CustomSearchBarView(
      {Key? key,
      required this.hint,
      this.controller,
      this.onSubmit,
      this.onChanged,
      this.autofocus = false})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomSearchBarViewState();
}

class _CustomSearchBarViewState extends ConsumerState<CustomSearchBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.primary,
        borderRadius: CustomThemeData.fullRounded,
      ),
      constraints: BoxConstraints(minHeight: 50.smh, minWidth: 330),
      width: 330.smw,
      height: 50.smh,
      child: Center(
        child: TextField(
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          controller: widget.controller,
          onSubmitted: widget.onSubmit,
          textAlignVertical: TextAlignVertical.center,
          style: CustomFonts.defaultField(CustomColors.secondaryText),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            prefixIcon: Icon(
              Icons.search,
              color: CustomColors.secondaryText,
            ),
            border: InputBorder.none,
            hintText: widget.hint,
            iconColor: CustomColors.secondaryText,
            hintStyle: CustomFonts.defaultField(CustomColors.secondaryText),
          ),
        ),
      ),
    );
  }
}
