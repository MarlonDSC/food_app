import 'package:cloud_firestore/cloud_firestore.dart';

class UserCard {
  String id;
  final String? fullName;
  final String? jobTitle;
  final String? description;
  final String? phoneNumber;
  final String? profilePictureURL;

  UserCard({
    this.id = '',
    required this.fullName,
    required this.jobTitle,
    required this.description,
    required this.phoneNumber,
    required this.profilePictureURL,
  });

  factory UserCard.fromFirestore(
    Map<String, dynamic> snapshot,
    // SnapshotOptions? options,
  ) {
    return UserCard(
      id: snapshot['id'],
      fullName: snapshot['fullName'],
      jobTitle: snapshot['jobTitle'],
      description: snapshot['description'],
      phoneNumber: snapshot['phoneNumber'],
      profilePictureURL: snapshot['profilePictureURL'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "fullName": fullName,
      "jobTitle": jobTitle,
      "description": description,
      "phoneNumber": phoneNumber,
      "profilePictureURL": profilePictureURL,
    };
  }
}
