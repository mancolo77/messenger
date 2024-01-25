import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': username,
        'uid': credential.user!.uid,
        'email': email,
        'online': true,
        'lastActive': FieldValue.serverTimestamp(), 
        });
        // При выходе пользователя
        await _firestore.collection('users').doc(credential.user!.uid).update({
          'online': false, // Устанавливаем статус "не в сети"
          'lastActive': FieldValue.serverTimestamp(), //Времени последней активности
         });   
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // showToast(message: 'Эта почта уже используется.');
      } else {
        // showToast(message: 'Ошибка: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await saveUserInfoToSharedPreferences(credential.user);
            await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        }, SetOptions(merge: true)
        );


      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // showToast(message: 'Неверный логин или пароль');
      } else {
        // showToast(message: 'Ошибка: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> checkUserStatus() async {
    return _auth.currentUser;
  }
  
  
  Future<void> signOut() async {
  await _auth.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  // Get.offAll(LoginScreen());

}
  Future<void> saveUserInfoToSharedPreferences(User? user) async{
    if (user != null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(user.uid);
      print(user.email);
      prefs.setString('user_uid', user.uid);
      prefs.setString('user_email', user.email ?? '');
    }
  }
    Future<String?> getUsername(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      return userSnapshot.get('username');
    } catch (e) {
      print('Ошибка при получении username: $e');
      return null;
    }
  }
}

