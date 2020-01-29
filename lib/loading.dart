import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vrent/main.dart';

class load extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.brown,
          size: 50.0,
          duration: const Duration(milliseconds: 5000),
        ),
      ),
    );
  }
}

class Launching extends StatefulWidget {
  @override
  _LaunchingState createState() => _LaunchingState();
}

class _LaunchingState extends State<Launching> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Container(

              child:  Image(
                fit: BoxFit.cover,
                image: AssetImage("images/VRENT.jpg"),

              ),

              height:MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width,



            ),


          Column(

            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return SignUp();
                  }));
                },
                child: Container(
                  child: Text("Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic
                  ),),
                  height: 55.0,
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,

                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return signin();
                  }));
                },
                child: Container(
                  child: Text("Log In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic
                  ),),
                  height: 55.0,
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,

                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 40.0,)
            ],
          ),
        ],

      )

    );
  }
}

