// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/card_model.dart';

// class FirebaseFirestoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Future<void> registerUser() async {
//     UserCard user = UserCard(
//       description: '',
//       fullName: '',
//       jobTitle: '',
//       phoneNumber: 0,
//       profilePictureURL: '',
//     );
//     await _firestore
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .set(user.toFirestore());
//   }
// }
