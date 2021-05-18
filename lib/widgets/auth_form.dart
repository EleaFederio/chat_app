import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {

  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String email, String username, String passwod, bool isLogin, BuildContext ctx) submitFn;

  // const AuthForm({Key key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userImageFile;


  void _pickedImage(File image){
    _userImageFile = image;
  }

  void _trySubmit(){
    final isValid = _formKey.currentState.validate();
    // close keyboard
    FocusScope.of(context).unfocus();

    if(_userImageFile == null && !_isLogin){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        )
      );
      return;
    }

    if(isValid){
      // trigger the onSave inside formFields
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userName.trim(), _userPassword.trim(), _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!_isLogin)
                  UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value){
                      if(value.isEmpty || !value.contains('@')){
                        return 'Please return a valid email';
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address'
                    ),
                    onSaved: (value){
                      // no need for set state : no need to refresh the screen
                      _userEmail = value;
                    },
                  ),
                  if(!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Username require.';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Username'
                    ),
                    onSaved: (value){
                      // no need for set state : no need to refresh the screen
                      _userName = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value){
                      if(value.isEmpty || value.length < 8){
                        return 'Password must be at least 7 characters.';
                      }else{
                        return null;
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password'
                    ),
                    onSaved: (value){
                      // no need for set state : no need to refresh the screen
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if(widget.isLoading)
                    CircularProgressIndicator(),
                  if(!widget.isLoading)
                  RaisedButton(
                    // style: ElevatedButton.styleFrom(
                    //
                    // ),
                    child: _isLogin ? Text('LOGIN') : Text('REGISTER'),
                    onPressed: _trySubmit,
                  ),
                  if(!widget.isLoading)
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryColor
                      )
                    ),
                    child: _isLogin ? Text('Create new account.') :
                    Text('I already have an account.'),
                    onPressed: (){
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
