import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class baseauth{
  Stream<String> get onauthchanged;
  Future<String> signinwithemailandpassword(String email,String password);
  Future<String> createuserwithemailandpassword(String email,String password);


  Future<String> currentuser();
  Future signout();

  Future<String> signinwithgoogle();
}
class auth implements baseauth{
  FirebaseAuth _auth=FirebaseAuth.instance;
  GoogleSignIn googleSignIn=GoogleSignIn();
  @override
  Future<String> createuserwithemailandpassword(String email, String password)  async {
    // TODO: implement createuserwithemailandpassword
    AuthResult result= (await _auth.createUserWithEmailAndPassword(email: email, password: password));
    FirebaseUser user=result.user;
    return user.uid;
  }

  @override
  Future<String> currentuser() async{
    // TODO: implement currentuser
    return (await _auth.currentUser()).uid;
  }

  @override
  // TODO: implement onauthchanged
  Stream<String> get onauthchanged => _auth.onAuthStateChanged.map((FirebaseUser user)=>user?.uid);


  @override
  Future<String> signinwithemailandpassword(String email, String password) async{
    // TODO: implement signinwithemailandpassword
    AuthResult result=(await _auth.signInWithEmailAndPassword(email: email, password: password));
    FirebaseUser user=result.user;
    return user.uid;
  }

  @override
  Future<String> signinwithgoogle() async{
    // TODO: implement signinwithgoogle
    final GoogleSignInAccount account=await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication=await account.authentication;
    final AuthCredential credential=GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    AuthResult result= (await _auth.signInWithCredential(credential));
    FirebaseUser user=result.user;
    return user.uid;
  }

  @override
  Future signout() async {
    // TODO: implement signout


     _auth.signOut();
  await googleSignIn.signOut();

  }

}