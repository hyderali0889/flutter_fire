import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  var email;
  var password;
  var email2;
  var password2;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference donks = FirebaseFirestore.instance.collection('donks');

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in! ${user.email}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 50),
      child: Column(
        children: [
          Center(
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.red))),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Enter password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.red))),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  }),
              TextButton(
                  onPressed: signupwithemail, child: const Text("Sign Up"))
            ]),
          ),
          Center(
            child: TextButton(
              child: const Text("sign Out"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ),
          Center(
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.red))),
                onChanged: (value) {
                  setState(() {
                    email2 = value;
                  });
                },
              ),
              TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Enter password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.red))),
                  onChanged: (value) {
                    setState(() {
                      password2 = value;
                    });
                  }),
              TextButton(
                  onPressed: signinwithemail, child: const Text("Sign In"))
            ]),
          ),
          Center(
              child: TextButton(
            child: const Text("Sign In With Google"),
            onPressed: signInWithGoogle,
          )),
          Center(
              child: TextButton(
            child: const Text("Add To Firestore"),
            onPressed: addtofirestore,
          )),
        ],
      ),
    ));
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void signupwithemail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signinwithemail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email2, password: password2);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  addtofirestore() {
    users
        .add({'full_name': "John Doe", 'company': "Stokes and Sons", 'age': 42})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    donks.add({"name": "donkey"});
  }
}
