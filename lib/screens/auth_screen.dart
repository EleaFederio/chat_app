import 'package:chat_app/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String email, String username, String password, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;

    try{
      if(isLogin){
        authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password
        );
      }else{
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
      }
    }on PlatformException catch (error){
      var message = 'Please check your credentials';
      if(error.message != null){
        message = error.message;
      }
    //  show error
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        )
      );
    } catch (error){
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
