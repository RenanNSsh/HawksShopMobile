import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/user_data.dart';
import 'package:hawks_shop/services/user_service.dart';

class AuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserService _userService = UserService();
  UserData _user;

  Future<UserData> signUp({@required UserData userData, @required String password}) async{
    FirebaseUser firebaseUser = await _auth.createUserWithEmailAndPassword(email: userData.email, password: password);
    _user = userData;
    _user.id = firebaseUser.uid;
    await _saveUserData(userData);
    return _user;
  }

   Future<Null> _saveUserData(UserData userData) async{
    return await _userService.saveUserData(userData);
  }
  
  Future<UserData> login({@required String email, @required String password}) async{
    FirebaseUser userFirebase = await _auth.signInWithEmailAndPassword(email: email, password: password);
    _user = UserData.fromFirebaseUser(userFirebase);
    await loadCurrentUser();
    return _user;
  }

  Future<void> loadCurrentUser() async {
    if(_user == null){
      FirebaseUser firebaseUser = await _auth.currentUser();
      _user = UserData.fromFirebaseUser(firebaseUser);
    }
    if(_user != null){
      if(_user.name == null){
        _user = await _userService.getUser(userId: _user.id);
      }
    }
  }

  Future<void> signOut() async{
    await _auth.signOut();
    _user = null;
  }

  Future<void> recoverPassword({@required String email}){
    return _auth.sendPasswordResetEmail(email: email);
  }
}