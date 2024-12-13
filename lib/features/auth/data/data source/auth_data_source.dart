import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mimo/core/constants/collections.dart';
import 'package:mimo/core/error/exception.dart';
import 'package:mimo/features/auth/data/model/user_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class AuthDataSource {
  Future<UserModel?> getUserData(String email);

  Future registerUser(UserModel user);

  Future updateUser(UserModel user);
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseFirestore firestoreDB;

  AuthDataSourceImpl(this.firestoreDB);

  @override
  Future<UserModel?> getUserData(String email) async {
    try {
      final response = await firestoreDB
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: email)
          .get();

      if (response.docs.isEmpty) {
        return null;
      } else {
        return UserModel.fromJson(response.docs.first);
      }
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future registerUser(UserModel user) async {
    try {
      await firestoreDB
          .collection(FirestoreCollections.users)
          .doc(
              '${user.email}_${user.userId}_${Uuid().v1()}_${DateTime.now().millisecondsSinceEpoch}')
          .set(user.toJson());
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future updateUser(UserModel user) async {
    try {
      final response = await firestoreDB
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: user.email)
          .get();

      if (response.docs.isNotEmpty) {
        await response.docs.first.reference.update({
          'name': user.name.isEmpty
              ? response.docs.first.data()['name']
              : user.name,
          'profilePicUrl': user.profilePicUrl.isEmpty
              ? response.docs.first.data()['profilePicUrl']
              : user.profilePicUrl,
          'location': user.location.isEmpty
              ? response.docs.first.data()['location']
              : user.location,
          'description': user.description.isEmpty
              ? response.docs.first.data()['description']
              : user.description,
          'fileId': user.fileId.isEmpty
              ? response.docs.first.data()['fileId']
              : user.fileId,
        });
      }
    } catch (e) {
      throw KustomException(e.toString());
    }
  }
}
