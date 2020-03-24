import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/services/user_service.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  final UserService _userService = UserService();

  bool _isLoading = false;

  static UserModel of(BuildContext context){
    return ScopedModel.of<UserModel>(context);
  }

  set isLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  bool get isLoading {
    return _isLoading;
  }

  @override
  void addListener(VoidCallback listener){
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp({@required Map<String, dynamic> userData, @required String password, @required VoidCallback onSuccess, @required VoidCallback onError}){
    isLoading = true;
    _auth.createUserWithEmailAndPassword(email: userData["email"], password: password).then((user) async {
      firebaseUser = user;
      await _saveUserData(userData);
      onSuccess();
    }).catchError((error){
      onError();
    }).whenComplete((){
      isLoading = false;
    });

  }

  void signIn({@required String email, @required String password, @required VoidCallback onSuccess, @required VoidCallback onError}) async {
    isLoading = true;
    _auth.signInWithEmailAndPassword(email: email, password: password).then((user) async {
      firebaseUser = user;
      await _loadCurrentUser();
      onSuccess();
    }).catchError((error){
      onError();
    })
    .whenComplete((){
      isLoading = false;
    });
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
    return await _userService.saveUserData(userId: firebaseUser.uid, userData: userData);
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }
    if(firebaseUser != null){
      if(userData["name"] == null){
        userData = await _userService.getUser(userId: firebaseUser.uid);
      }
    }
    notifyListeners();
  }
}