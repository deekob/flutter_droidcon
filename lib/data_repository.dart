import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_droidcon/models/UserProfile.dart';

class DataRepository {
  Future<UserProfile?> getUserById(String? userId) async {
    try {
      final users = await Amplify.DataStore.query(
        UserProfile.classType,
        where: UserProfile.ID.eq(userId),
      );

      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      throw e;
    }
  }

  Future<UserProfile> createProfile(
      {String? userId, required String userName, String? email}) async {
    final newUserProfile =
        UserProfile(id: userId, userName: userName, email: email);
    try {
      await Amplify.DataStore.save(newUserProfile);
      return newUserProfile;
    } catch (e) {
      throw e;
    }
  }
}
