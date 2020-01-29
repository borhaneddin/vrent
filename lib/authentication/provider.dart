import 'package:flutter/material.dart';
import 'Auth.dart';

class provider extends InheritedWidget{
  final baseauth auth;
  provider({
    Key key,
    Widget child,
    this.auth

}):super(
    key :key,
    child:child
  );



  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
  static provider of(BuildContext context)=>(context.inheritFromWidgetOfExactType(provider)as provider);

}