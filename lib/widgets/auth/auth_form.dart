import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Function submitForm;

  const AuthForm({Key? key, required this.submitForm}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isLogin = true;
  bool isLoginFormLoading = false;
  bool isSendingMail = false;
  bool isObscureText = true;
  File? _userDisplayPicture;

  final _form = GlobalKey<FormState>();

  late String email;
  String? username;
  late String password;

  void _pickedImage(File? image) {
    _userDisplayPicture = image;
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    bool? isValidate = _form.currentState?.validate();
    if (isValidate == null || !isValidate) {
      return;
    } else if (_userDisplayPicture == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please pick an image as a display picture."),
        duration: Duration(seconds: 3),
      ));
      return;
    } else {
      _form.currentState?.save();
      setState(() => isLoginFormLoading = true);
      try {
        await widget.submitForm(
            email, password, username, _userDisplayPicture, isLogin);
      } finally {
        setState(() => isLoginFormLoading = false);
      }
    }
  }

  Future<void> _forgotPasswordBox() {
    final forgotForm = GlobalKey<FormState>();
    late String email;
    bool isError = false;
    return showDialog(
        context: (context),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              if (isSendingMail) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return AlertDialog(
                title: const Text("Enter Details"),
                content: Form(
                  key: forgotForm,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      final emailRegex = RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                      if (value == null || value.isEmpty) {
                        return "Please enter an email address";
                      } else if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      bool? isValidate = forgotForm.currentState?.validate();
                      if (isValidate == null || !isValidate) {
                        return;
                      } else {
                        forgotForm.currentState?.save();
                        try {
                          setState(() => isSendingMail = true);
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);
                        } on FirebaseAuthException catch (error) {
                          isError = true;
                          String message = error.message as String;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 3),
                              content: Text(message),
                            ),
                          );
                        } catch (error) {
                          isError = true;
                          String message =
                              "Error occurred! Please check your connection and retry";
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 3),
                              content: Text(message),
                            ),
                          );
                        } finally {
                          setState(() => isSendingMail = false);
                          Navigator.of(context).pop();
                          if (!isError) {
                            String message = "Password reset mail was sent";
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Text(message),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text("Send Recovery Mail"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin)
                    UserImagePicker(imagePickFunction: _pickedImage),
                  TextFormField(
                    key: const ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: "Email Address"),
                    validator: (value) {
                      final emailRegex = RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                      if (value == null || value.isEmpty) {
                        return "Please enter an email address";
                      } else if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) => email = value!,
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      decoration: const InputDecoration(labelText: "Username"),
                      validator: (value) {
                        final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        } else if (!usernameRegex.hasMatch(value)) {
                          return 'Username must be 3-20 characters long \nand can contain letters, numbers, \nunderscores, and hyphens';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) => username = value!,
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const ValueKey("password"),
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          obscureText: isObscureText,
                          validator: (value) {
                            if (isLogin) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a password";
                              }
                              return null;
                            } else {
                              final passwordRegex = RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (!passwordRegex.hasMatch(value)) {
                                return 'Password must be at least 8 characters long \nand contain at least one lowercase letter, \none uppercase letter, and one digit';
                              }
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (value) => password = value!,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            setState(() => isObscureText = !isObscureText),
                        icon: Icon(isObscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  isLoginFormLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _saveForm,
                          child: Text(isLogin ? "Login" : "Sign Up"),
                        ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      TextButton(
                        onPressed: isLoginFormLoading
                            ? null
                            : () => setState(() => isLogin = !isLogin),
                        child: Text(isLogin
                            ? "Create New Account"
                            : "I already have an account"),
                      ),
                      if (isLogin)
                        TextButton(
                          onPressed:
                              isLoginFormLoading ? null : _forgotPasswordBox,
                          child: const Text("Forgot Password?"),
                        ),
                    ],
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
