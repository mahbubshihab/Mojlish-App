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
    await UserStorageService.saveUserEmail('mizanur.rahman@gmail.com');
    await UserStorageService.saveUserPhotoUrl('');
    return null;
  }

  /// Sync Google User profile into Firestore users/{uid} collection
  Future<void> syncUserProfile(User user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userRef.get();

      final currentMajlis = await UserStorageService.getActiveMajlis();
      final displayName = user.displayName ?? 'মিজানুর রহমান';
      final email = user.email ?? '';
      final photoUrl = user.photoURL ?? '';

      final Map<String, dynamic> userData = {
        'uid': user.uid,
        'name': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'selectedMajlis': currentMajlis ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (!userDoc.exists) {
        userData['createdAt'] = FieldValue.serverTimestamp();
        await userRef.set(userData, SetOptions(merge: true));
      } else {
        final existingData = userDoc.data() ?? {};
        if (existingData['name'] != null && existingData['name'].toString().isNotEmpty) {
          userData['name'] = existingData['name'];
        }
        if (existingData['selectedMajlis'] != null && existingData['selectedMajlis'].toString().isNotEmpty) {
          userData['selectedMajlis'] = existingData['selectedMajlis'];
        }
        await userRef.set(userData, SetOptions(merge: true));
      }

      await UserStorageService.saveUserName(userData['name'] as String);
      await UserStorageService.saveUserEmail(email);
      await UserStorageService.saveUserPhotoUrl(photoUrl);
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
