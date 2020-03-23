import 'package:flutter/material.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context,child,model){
          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);
          return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Nome Completo",),
                    validator: (text){
                      if(text.isEmpty){
                        return "Nome inválido!";
                      }
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail",),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
                      if(text.isEmpty || !text.contains("@")){
                        return "E-mail inválido!";
                      }
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text){
                      if(text.isEmpty){
                        return "Senha inválida";
                      }
                    },
                  ),
                   SizedBox(height: 16.0,),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Digite a senha novamente"),
                    obscureText: true,
                    validator: (text){
                      if(text.isEmpty){
                        return "Senha inválida";
                      }
                      if(text.length < 6){
                        return "A senha é muito curta!";
                      }
                      if(text != _passwordController.text){
                        return "As senhas não são iguais";
                      }
                    },
                  ),
                  
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(hintText: "Endereço",),
                    validator: (text){
                      if(text.isEmpty){
                        return "Endereço inválido!";
                      }
                    },
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Cadastrar", style: TextStyle(fontSize: 18.0),),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate()){

                          Map<String,dynamic> userData = {
                            "name": _nameController.text.trim(),
                            "email": _emailController.text.trim(),
                            "address": _addressController.text.trim()
                          };
                          model.signUp(userData: userData, password: _passwordController.text, onSuccess: _onSuccess, onError: _onError);
                        }
                      },
                    ),
                  ),
                  
                ],
              ),
            );
        },
      )
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onError(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar usuário!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      )
    );
  }
}