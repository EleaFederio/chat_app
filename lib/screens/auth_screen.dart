
import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  var _isLoading = false;

  void showError(String errorMessage, BuildContext ctx){
    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(ctx).errorColor,
        )
    );
  }

  void _submitAuthForm(String email, String username, String password, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;

    try{
      setState(() {
        _isLoading = true;
      });
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
        //  Add other User Details
        await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user.uid)
        .set({
          'username' : username,
        });
      }

    }on PlatformException catch (error){
      var message = 'Please check your credentials';
      if(error.message != null){
        message = error.message;
      }
    //  show error
      showError(message, ctx);
      setState(() {
        _isLoading = false;
      });
    } catch (error){
      String errorMessage = error.message.toString();
      showError(errorMessage, ctx);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
