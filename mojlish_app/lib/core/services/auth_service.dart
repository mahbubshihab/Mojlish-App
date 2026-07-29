import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mojlish_app/core/services/user_storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Google Sign-In Flow
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          await syncUserProfile(userCredential.user!);
        }
        return userCredential;
      }
    } catch (e) {
      print('Google sign in bypassed: $e');
    }
    await UserStorageService.saveUserName('মিজানুর রহমান');
    return null;
  }

  /// Sync Google User profile into Firestore users/{uid}
  Future<void> syncUserProfile(User user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userRef.get();

      final currentMajlis = await UserStorageService.getActiveMajlis();
      final displayName = user.displayName ?? 'ব্যবহারকারী';

      if (!userDoc.exists) {
        await userRef.set({
          'uid': user.uid,
          'name': displayName,
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'selectedMajlis': currentMajlis ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        await UserStorageService.saveUserName(displayName);
      } else {
        final data = userDoc.data() ?? {};
        final savedName = data['name'] ?? displayName;
        final savedMajlis = data['selectedMajlis'] ?? currentMajlis ?? '';

        await UserStorageService.saveUserName(savedName);
        if (savedMajlis.isNotEmpty) {
          await UserStorageService.saveActiveMajlis(savedMajlis);
        }

        await userRef.set({
          'photoUrl': user.photoURL ?? data['photoUrl'] ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Firestore syncUserProfile exception: $e');
    }
  }

  /// Update user display name in Firestore & UserStorageService
  Future<void> updateUserName(String newName) async {
    final trimmed = newName.trim();
    try {
      final user = currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': trimmed,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        await user.updateDisplayName(trimmed);
      }
    } catch (e) {
      print('Firestore updateUserName exception: $e');
    }
    await UserStorageService.saveUserName(trimmed);
  }

  /// Update selected majlis in Firestore & UserStorageService
  Future<void> updateActiveMajlis(String majlisName) async {
    try {
      final user = currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'selectedMajlis': majlisName,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Firestore updateActiveMajlis exception: $e');
    }
    await UserStorageService.saveActiveMajlis(majlisName);
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('SignOut exception: $e');
    }
  }
}
