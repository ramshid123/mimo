class UserEntity {
  String name;
  String userId;
  String email;
  String profilePicUrl;
  String location;
  String description;
  String fileId;

  UserEntity({
    required this.name,
    required this.userId,
    required this.email,
    required this.profilePicUrl,
    required this.location,
    required this.description,
    required this.fileId,
  });

  UserEntity copyWith({
    String? name,
    String? userId,
    String? email,
    String? profilePicUrl,
    String? location,
    String? description,
    String? fileId,
  }) {
    return UserEntity(
      name: name ?? this.name,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      location: location ?? this.location,
      description: description ?? this.description,
      fileId: fileId ?? this.fileId,
    );
  }
}
