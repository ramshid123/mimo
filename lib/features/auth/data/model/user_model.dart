import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mimo/core/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.name,
    required super.profilePicUrl,
    required super.email,
    required super.location,
    required super.description,
    required super.fileId,
  });

  factory UserModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return UserModel(
      userId: json.data()['userId'],
      name: json.data()['name'],
      email: json.data()['email'],
      profilePicUrl: json.data()['profilePicUrl'],
      location: json.data()['location'],
      description: json.data()['description'],
      fileId: json.data()['fileId'],
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      profilePicUrl: entity.profilePicUrl,
      location: entity.location,
      email: entity.email,
      description: entity.description,
      fileId: entity.fileId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profilePicUrl': profilePicUrl,
      'email': email,
      'location': location,
      'fileId': fileId,
      'description': description,
    };
  }
}
