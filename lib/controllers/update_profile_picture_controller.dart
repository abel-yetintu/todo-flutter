import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/image_picker_service.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/services/storage_service.dart';

final updateProfilePictureControllerProvider = AutoDisposeNotifierProvider<UpdateProfilePictureController, void>(() {
  return UpdateProfilePictureController();
});

class UpdateProfilePictureController extends AutoDisposeNotifier<void> {
  @override
  void build() {}

  Future<void> updateProfilePicture({required ImageSource imageSource, required TodoUser todoUser}) async {
    try {
      var file = await getIt<ImagePickerService>().pickImage(imageSource: imageSource);
      if (file != null) {
        showNonDismissibleLoadingDialog(getIt<GlobalKey<NavigatorState>>().currentContext!);
        await getIt<StorageService>().uploadProficePicture(file: file, todoUser: todoUser);
        getIt<NavigationService>().goBack();
        HelperFunctions.showSnackBar(message: 'Profile picture updated');
      }
    } on PlatformException catch (e) {
      HelperFunctions.showErrorSnackBar(message: 'Failed to Pick image: $e');
    } catch (e) {
      getIt<NavigationService>().goBack();
      debugPrint(e.toString());
      HelperFunctions.showErrorSnackBar(message: 'Unkown error. Please try again later');
    }
  }

  Future<void> removeProfilePicture({required TodoUser todoUser}) async {
    try {
      showNonDismissibleLoadingDialog(getIt<GlobalKey<NavigatorState>>().currentContext!);
      await getIt<StorageService>().removeProfilePicture(todoUser: todoUser);
      getIt<NavigationService>().goBack();
       HelperFunctions.showSnackBar(message: 'Profile picture removed');
    } catch (_) {
      getIt<NavigationService>().goBack();
      HelperFunctions.showErrorSnackBar(message: 'Unkown error. Please try again later');
    }
  }
}
