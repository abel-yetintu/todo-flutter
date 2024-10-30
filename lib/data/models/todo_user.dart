import 'package:cloud_firestore/cloud_firestore.dart';

class TodoUser {
  final String uid;
  final String email;
  final String userName;
  final String fullName;
  final String profilePicture;

  TodoUser({
    required this.uid,
    required this.email,
    required this.userName,
    required this.fullName,
    required this.profilePicture,
  });

  TodoUser copyWith({
    String? uid,
    String? email,
    String? userName,
    String? fullName,
    String? profilePicture,
  }) {
    return TodoUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'profilePicture': profilePicture,
    };
  }

  factory TodoUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return TodoUser(
      uid: data['uid'] as String,
      email: data['email'] as String,
      userName: data['userName'] as String,
      fullName: data['fullName'] as String,
      profilePicture: data['profilePicture'] as String,
    );
  }

  factory TodoUser.fromMap(Map<String, dynamic> map) {
    return TodoUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      userName: map['userName'] as String,
      fullName: map['fullName'] as String,
      profilePicture: map['profilePicture'] as String,
    );
  }

}
