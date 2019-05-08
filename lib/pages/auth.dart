import 'package:first_app/main.dart';
import 'package:first_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

enum AuthMode { SignUp, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.9,
                    ),
                    _buildPasswordTextField(),
                    _authMode == AuthMode.SignUp
                        ? _buildPassWordConfirmTextField()
                        : Container(),
                    _buildAcceptSwitch(),
                    SizedBox(
                      height: 10.9,
                    ),
                    FlatButton(
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'SignUp' : 'Login'}'),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.SignUp
                              : AuthMode.Login;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text('LOGIN'),
                          onPressed: () =>
                              _submitForm(model.login, model.signUp),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/background.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
//      controller: _emailTextController,
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        setState(() {
          _formData['email'] = value;
        });
      },
    );
  }

  Widget _buildPassWordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'please ensure passwords are the same';
        }
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      controller: _passwordTextController,
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _formData['password'] = value;
        });
      },
    );
  }

  void _submitForm(Function login, Function signUp) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    if (_authMode == AuthMode.Login) {
      print(_formData['email']);
      print(_formData['password']);
      login(_formData['email'], _formData['password']);
    } else {
      print(_formData['email']);
      print(_formData['password']);
      final Map<String, dynamic> successInformation =
          await signUp(_formData['email'], _formData['password']);
      if (successInformation['success']) {
        Navigator.pushReplacementNamed(context, '/products');
      } else {
        showDialog(context: context,builder: (BuildContext context) {
          return AlertDialog(
            title: Text( 'An error occured'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(child: Text('Close'),
              onPressed: (){
                Navigator.of(context).pop();
              },)
            ],
          );
        });
      }
    }
  }
}
