import 'dart:ffi';
import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) _submitForm;

  final bool _isLoading;
  AuthForm(this._submitForm, this._isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, bool> customFormValidation = {
    'isValidUsername': true,
    'isValidEmail': true,
    'isValidPassword': true
  };

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogin = true;
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submit() {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('you need to pick an image !')));
      return;
    }

    if (_isValid) {
      _formKey.currentState!.save();
      widget._submitForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile ?? File('emptyFile.txt'),
        _isLogin,
        context,
      );
    }
  }

// // fatmaridene1
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble,
            size: 100,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "chatty !",
            style: GoogleFonts.bebasNeue(fontSize: 52),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Welcome Back, you've been missed !",
              style: TextStyle(fontSize: 20)),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLogin
                    ? SizedBox(
                        height: 50,
                      )
                    : SizedBox(
                        height: 25,
                      ),
                if (!_isLogin) UserImagePicker(_pickedImage),
                //* login email input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            setState(() {
                              customFormValidation = {
                                'isValidEmail': false,
                                'isValidUsername':
                                    customFormValidation['isValidUsername']
                                        as bool,
                                'isValidPassword':
                                    customFormValidation['isValidPassword']
                                        as bool
                              };
                            });    
                            return null;                
                          }
                          return null;
                        },
                        onChanged: ((value) {
                          if(!value!.isEmpty && value.contains('@'))
                           setState(() {
                              customFormValidation = {
                                'isValidEmail': true,
                                'isValidUsername':
                                    customFormValidation['isValidUsername']
                                        as bool,
                                'isValidPassword':
                                    customFormValidation['isValidPassword']
                                        as bool
                              };
                            });
                        }),
                        onSaved: (value) {
                          _userEmail = value as String;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Email'),
                      ),
                    ),
                  ),
                ),
                if (!customFormValidation['isValidEmail']! as bool)
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(
                      'Please Enter a Valid Email.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.red,
                        
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                if (!_isLogin)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              setState(() {
                                customFormValidation = {
                                  'isValidEmail':
                                      customFormValidation['isValidEmail']
                                          as bool,
                                  'isValidUsername': false,
                                  'isValidPassword':
                                      customFormValidation['isValidPassword']
                                          as bool
                                };
                              });
                              return null;
                            }
                            return null;
                          },

                          onChanged: (value) {
                            if (!value!.isEmpty && value.length > 4) {
                              setState(() {
                                customFormValidation = {
                                  'isValidEmail':
                                      customFormValidation['isValidEmail']
                                          as bool,
                                  'isValidUsername': true,
                                  'isValidPassword':
                                      customFormValidation['isValidPassword']
                                          as bool
                                };
                              });
                              return null;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userName = value as String;
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'username',
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  if (!customFormValidation['isValidUsername']! as bool && !_isLogin)
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(
                      'Please Enter a username with 4 characters at least.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.red,
                        
                      ),
                    ),
                  ),
                if (!_isLogin)
                  SizedBox(
                    height: 10,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            setState(() {
                              customFormValidation = {
                                'isValidEmail':
                                    customFormValidation['isValidEmail']
                                        as bool,
                                'isValidUsername':
                                    customFormValidation['isValidUsername']
                                        as bool,
                                'isValidPassword': false
                              };
                            });
                            return null;
                          }
                          return null;
                        },

                        onChanged: ((value) {
                                    if (!value!.isEmpty && value.length > 7) {
                            setState(() {
                              customFormValidation = {
                                'isValidEmail':
                                    customFormValidation['isValidEmail']
                                        as bool,
                                'isValidUsername':
                                    customFormValidation['isValidUsername']
                                        as bool,
                                'isValidPassword': true
                              };
                            });
                            return null;
                          }
                          return null;
                        }),
                        onSaved: (value) {
                          _userPassword = value as String;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Password'),
                        obscureText: true,
                      ),
                    ),
                  ),
                ),
                 if (!customFormValidation['isValidPassword']! as bool)
                    Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(
                      'Please Enter a Password with 7 characters at least.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.red,
                        
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (widget._isLoading)
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircularProgressIndicator(),
                  ),
                if (!widget._isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: _submit,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            _isLogin ? 'Login' : 'Signup',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 25,
                ),
                if (!widget._isLoading)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: _isLogin
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              // ignore: prefer_const_constructors
                              Text(
                                "Don't have an account ?, ",
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // ignore: prefer_const_constructors
                              Text(
                                "Register Now.",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                "Already have an account ?, ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // ignore: prefer_const_constructors
                              Text(
                                "Login Now.",
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
/*
      ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Login' : 'Signup'),
                ),

                 child: Text(_isLogin
                      ? 'Create new Account'
                      : 'I already have an account'),
 */
