import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit(){
    final isValid = _formKey.currentState.validate();
    // close keyboard
    FocusScope.of(context).unfocus();

    if(isValid){
      // trigger the onSave inside formFields
      _formKey.currentState.save();
      print(_userName);
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
                  RaisedButton(
                    // style: ElevatedButton.styleFrom(
                    //
                    // ),
                    child: _isLogin ? Text('LOGIN') : Text('REGISTER'),
                    onPressed: _trySubmit,
                  ),
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
