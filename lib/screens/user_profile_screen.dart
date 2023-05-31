import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.titleSmall!;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(userId).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Hey ${snapshot.data["username"]}!"),
            ),
            body: Container(
              margin: const EdgeInsets.only(top: 70, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("UserID:", style: textStyle),
                      Text(userId as String, style: textStyle),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email:", style: textStyle),
                      Text(snapshot.data["email"], style: textStyle),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Your Display Picture", style: textStyle),
                      Image.network(
                        snapshot.data["image_url"],
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
