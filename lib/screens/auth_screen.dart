import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> submitAuthForm(
      String email, String password, String? username, bool isLogin) async {
    UserCredential result;
    try {
      if (isLogin) {
        result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(result.user?.uid)
            .set({"username": username, "email": email});
      }
    } on FirebaseAuthException catch (error) {
      String message = "An error occurred, please check your connection!";
      message = error.message as String;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 3000),
        content: Text(message),
      ));
    } catch (error) {
      String message = "Error occurred! Please check your connection and retry";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 3000),
        content: Text(message),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(submitForm: submitAuthForm),
    );
  }
}
