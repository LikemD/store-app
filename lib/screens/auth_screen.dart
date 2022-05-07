import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exceptions.dart';
import 'package:shop_app/viewmodels/auth_provider.dart';

enum AuthType { SignUp, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
              content: Text(errorMessage),
            ));
  }

  Future<void> signUp(String email, String password) async {
    if (_form.currentState!.validate())
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(email, password);
      } on HttpException catch (error) {
        var errorMessage =
            'Authentication failed with server. Please provide valid registration credentials';
        if (error.toString().contains('EMAIL_EXISTS'))
          errorMessage = 'Email already exists';
        else if (error.toString().contains('INVALID_EMAIL'))
          errorMessage = 'This email address is invalid. Please try again.';
        else if (error.toString().contains('WEAK_PASSWORD'))
          errorMessage = 'Please provide a strong password';
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage = 'Oops Something went wrong. Please try again';
        _showErrorDialog(errorMessage);
      }
  }

  Future<void> signIn(String email, String password) async {
    if (_form.currentState!.validate())
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .signIn(email, password);
      } on HttpException catch (error) {
        var errorMessage =
            'Authentication failed with server. Please provide valid login credentials';
        if (error.toString().contains('EMAIL_NOT_FOUND'))
          errorMessage = 'We could not find a user with the specified email. Please try again.';
        else if (error.toString().contains('INVALID_PASSWORD'))
          errorMessage = 'Wrong password. Please try again';
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage = 'Oops Something went wrong. Please try again';
        _showErrorDialog(errorMessage);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal[200],
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/armoury.png',
              width: 300,
              height: 100,
            ),
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      var val = value as String;
                      if (val.isEmpty) return 'Please enter a Name';
                      return null;
                    },
                    onFieldSubmitted: (_) {},
                    onSaved: (value) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      var val = value as String;
                      if (val.isEmpty) return 'Please enter a Password';
                      return null;
                    },
                    onFieldSubmitted: (_) {},
                    onSaved: (value) {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: ElevatedButton(
                        onPressed: () {
                          signIn(_email.text, _password.text);
                        },
                        child: Text('Log In'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            fixedSize:
                                MaterialStateProperty.all(Size.fromHeight(48)),
                            elevation: MaterialStateProperty.all(0))))),
            SizedBox(
              height: 16,
            ),
            Container(
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: ElevatedButton(
                        onPressed: () {
                          signUp(_email.text, _password.text);
                        },
                        child: Text('Create New Account'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            fixedSize:
                                MaterialStateProperty.all(Size.fromHeight(48)),
                            elevation: MaterialStateProperty.all(0)))))
          ],
        ),
      ),
    );
  }
}
