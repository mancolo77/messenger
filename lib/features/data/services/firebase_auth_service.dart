import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/data/services/show_toast.dart';

class FirebaseAuthService extends ChangeNotifier{
  //Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Логин пользователя
Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async{
  try{
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      },SetOptions(merge: true)
      );
      return userCredential;
  } on FirebaseAuthException catch (e){
    if (e.code == 'user-not-found'|| e.code == 'wrong-password'){
      showToast('Неверный логин или пароль');
    } else {
     showToast('Ошибка: ${e.code}');
    }
  }
  return null;
}

  Future<User?> checkUserStatus() async {
    return _firebaseAuth.currentUser;
  }

Future<void> signOut() async{
  return await FirebaseAuth.instance.signOut();
}
// Регистрация пользователя
Future<UserCredential?> signUpWithEmailAndPassword(
  String email, String password, String username) async {
    try {
      UserCredential userCredential = 
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'uid': userCredential.user!.uid,
        'email': email,
        'online': true,
        'lastActive': FieldValue.serverTimestamp(), 
      });

      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'online': false,
        'lastActive': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e){
      if (e.code == 'email-already-in-use') {
        showToast('Эта почта уже используется');
      } else {
        showToast('Ошибка: ${e.code}');
      }
    }
    return null;
}

    Future<String?> getUsername(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      return userSnapshot.get('username');
    } catch (e) {
      showToast('Ошибка при получении username: $e');
      return null;
    }
  }
}