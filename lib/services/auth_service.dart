import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // current user
  User? get currentUser => _auth.currentUser;

  // reload user
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  // sign in with email and password
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({required String email, required String password, required String displayName}) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await updateDisplayName(displayName: displayName);
    return userCredential;
  }

  // update display name
  Future<void> updateDisplayName({required String displayName}) async {
    await currentUser!.updateDisplayName(displayName);
    await currentUser!.reload();
  }

  // send verification email
  Future<void> sendVerificationEmail() async {
    await currentUser!.sendEmailVerification();
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // reset password
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // re-authenticate user
  Future<UserCredential> reAuthenticateUser({required String password}) async {
    final credential = EmailAuthProvider.credential(email: currentUser!.email!, password: password);
    final result = await currentUser!.reauthenticateWithCredential(credential);
    return result;
  }

  // delete user
  Future<void> deleteUser() async {
    await _auth.currentUser!.delete();
  }

  // update email
  Future<void> updateEmail({required String newEmail}) async {
    await currentUser!.verifyBeforeUpdateEmail(newEmail);
  }
}
