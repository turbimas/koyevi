// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';

class UserDeleteViewModel extends ChangeNotifier {
  UserDeleteViewModel();

  Future<void> deleteUser(String password) async {
    try {
      ResponseModel responseModel = await NetworkService.get(
          "users/deleteuser/${AuthService.id}/$password");
      if (responseModel.success) {
        AuthService.logout(showSuccessMessage: true);
        NavigationService.back();
        NavigationService.context.read<HomeIndexCubit>().set(2);
      } else {
        PopupHelper.showErrorDialog(errorMessage: responseModel.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
