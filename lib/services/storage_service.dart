import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/database_service.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late final Reference _profilePicturesDirRef;

  StorageService() {
    _profilePicturesDirRef = _storage.ref('images/profile_pictures');
  }

  Future<void> uploadProficePicture({required File file, required TodoUser todoUser}) async {
    // upload image to storage
    Reference uploadImageRef = _profilePicturesDirRef.child('${todoUser.uid}_pp');
    await uploadImageRef.putFile(file);

    // update user documnt
    var downloadUrl = await uploadImageRef.getDownloadURL();
    var updatedUser = todoUser.copyWith(profilePicture: downloadUrl);
    await getIt<DatabaseService>().updateUser(todoUser: updatedUser);
  }

  Future<void> removeProfilePicture({required TodoUser todoUser}) async {
    if (todoUser.profilePicture == '') return;

    // update user document
    var updatedUser = todoUser.copyWith(profilePicture: '');
    await getIt<DatabaseService>().updateUser(todoUser: updatedUser);

    // delete image from storage
    var deleteImageRef = _profilePicturesDirRef.child('${todoUser.uid}_pp');
    await deleteImageRef.delete();
  }
}
