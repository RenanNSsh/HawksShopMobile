import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hawks_shop/datas/user_data.dart';
import 'package:hawks_shop/services/auth_service.dart';
import 'package:hawks_shop/services/user_service.dart';

class UserModel extends Model{

  UserData userData;
  final AuthService _authService = AuthService();
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

  Future<void> signUp({@required UserData userData, @required String password}){
    isLoading = true;
    return _authService.signUp(userData: userData, password: password).then((user){
      this.userData = user;
    }).whenComplete((){
        isLoading = false;
      }
    );
  }

  Future<void> signIn({@required String email, @required String password}) async {
    isLoading = true;
    try{
      UserData user = await _authService.login(email: email, password: password);
      this.userData = user;
    }catch(error){
      throw(error);
    }finally{
      isLoading = false;
    }
  }

  void recoverPassword({@required String email}){
    _authService.recoverPassword(email: email);
  }

  bool isLoggedIn(){
    return userData != null;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    userData = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    await _authService.loadCurrentUser();
    notifyListeners();
  }
}