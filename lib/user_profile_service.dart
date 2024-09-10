import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to get the current user's ID from Firebase
  Future<String?> getUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid; // Return the Firebase user ID
    } else {
      return null; // User not logged in
    }
  }

  // Additional methods for user profile management can be added here
}
