import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vrent/userProfile/UserProfile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter/services.dart';
import 'package:vrent/authentication/Auth.dart' as prefix0;
import 'package:vrent/product/catagory.dart';
import 'package:vrent/product/vehicles.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'package:intl/intl.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'authentication/Auth.dart';
import 'authentication/provider.dart';
import 'loading.dart';

bool loading=false;

void main(){
  runApp(myapp());
}
class myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return provider(
      auth: auth(),
      child: MaterialApp(
        title: "firebase connection",
        routes: {
          "/login":(context)=>signin(),
//          "/homepage":(context)=>Mfirebase(),
          "/displycars":(context)=>Vehicles()

        },
//        home:Profile(),
//        home:Launching(),
//        home:homepage(),
        home:myhomepage(),
//        home:carDetails(),
//        home:Vehicles(),
      ),
    );
  }
}
class myhomepage extends StatefulWidget {
  @override
  _myhomepageState createState() => _myhomepageState();
}

class _myhomepageState extends State<myhomepage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot.hasData){
            FirebaseUser user = snapshot.data; // this is your user instance
            if(FirebaseAuth.instance.currentUser()!=null){
              return homepage(user.uid);
            }
            /// is because there is user already logge
          }
          /// other way there is no user logged.
          return Launching();

        }
    );
  }
}
class homepage extends StatefulWidget {
  String userid;
  homepage(this.userid);
  @override
  _homepageState createState() => _homepageState();
}
class _homepageState extends State<homepage> {
  //start trip time
  TimeOfDay stime=TimeOfDay.now();
  void starttime(BuildContext context){
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time){
      stime=time;
      etime=time;
    });
  }
  Future<Null> showdate(BuildContext context) async{
    DateTime pickerdate=await showDatePicker(
        context: context,

        initialDatePickerMode: DatePickerMode.day,

        initialDate:DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2030));
    if(pickerdate!=null&&pickerdate!=DateTime.now()){
      setState(() {
        startdate=pickerdate;
        starttime(context);
      });
    }

  }
  DateTime startdate=null;

  //end trip time
  TimeOfDay etime=TimeOfDay.now();
//  void endtime(BuildContext context){
//    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time){
//      etime=time;
//    });
//  }
  Future<Null> showenddate(BuildContext context) async{
    DateTime pickerdate=await showDatePicker(
        context: context,

        initialDatePickerMode: DatePickerMode.day,

        initialDate:DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2030));
    if(pickerdate!=null&&pickerdate!=DateTime.now()){
      setState(() {
        enddate=pickerdate;
//        endtime(context);
      });
    }

  }
  DateTime enddate=null;
  TextEditingController cityname=TextEditingController();
  var formater=new DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("V RENT"),

        ),
        drawer: StreamBuilder(
            stream: Firestore.instance.collection("UserData").document(widget.userid).snapshots(),
            builder: (context, snapshot) {
              var docref=snapshot.data;
              return !snapshot.hasData?CircularProgressIndicator():Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(

                        color: Colors.pink,
                      ),
                      accountName: Text(docref['name']),
                      accountEmail: Text(docref['email']),
                      currentAccountPicture:Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image:DecorationImage(image:NetworkImage(docref['image']),fit: BoxFit.cover)
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        final  FirebaseUser user=await FirebaseAuth.instance.currentUser();
                        final userid=user.uid;
                        Fluttertoast.showToast(msg: userid,toastLength: Toast.LENGTH_LONG);
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (_){
                          return Profile(userid);
                        }));
                      },//Navigatior
                      child: ListTile(
                        leading: Icon(Icons.person,size: 35.0,color: Colors.lightBlue,),
                        title: Text("My Account",style: TextStyle(
                          fontSize: 20.0,
                          fontStyle:FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {

                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return catagoryDetails();
                          }));


                        });
                      },//Navigatior
                      child: ListTile(
                        leading: Icon(Icons.category,size: 35.0,color: Colors.lightBlue,),
                        title: Text("View Vehicles",style: TextStyle(
                          fontSize: 20.0,
                          fontStyle:FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),InkWell(
                      onTap: (){},//Navigatior
                      child: ListTile(
                        leading: Icon(Icons.search,size: 35.0,color: Colors.lightBlue,),
                        title: Text("Search Vehicle",style: TextStyle(
                          fontSize: 20.0,
                          fontStyle:FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),
                    InkWell(
                      onTap: (){},//Navigatior
                      child: ListTile(
                        leading: Icon(Icons.control_point,size: 35.0,color: Colors.lightBlue,),
                        title: Text("Our Policy",style: TextStyle(
                          fontSize: 20.0,
                          fontStyle:FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),
                    InkWell(
                      onTap: (){},//Navigatior
                      child: ListTile(
                        leading: Icon(Icons.share,size: 35.0,color: Colors.blue,),
                        title: Text("Share",style: TextStyle(
                          fontSize: 20.0,
                          fontStyle:FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),
                    InkWell(
                      onTap: (){},//Navigatior
                      child: ListTile(
                        leading: Icon(Icons.help,size: 35.0,color: Colors.blue,),
                        title: Text("Help",style: TextStyle(
                          fontSize: 20.0,
                          fontStyle:FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{


                        await FirebaseAuth.instance.signOut();
//                        Future<FirebaseUser> Function() user = FirebaseAuth.instance.currentUser;
//                        runApp(
//                            new MaterialApp(
//                              home: new Launching(),
//                            )
//
//                        );
//                        return user;
                        //print('$user');



                      },//Navigatior
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app,size: 35.0,color: Colors.blue),
                        title: Text("Log Out",style: TextStyle(
                          fontSize: 20.0,
                          fontStyle:FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                    )

                  ],
                ),
              );
            }
        ),
        body:Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 7.0),
          child: ListView(
//        mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Own A Car Without Buying It!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                elevation: 5.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(5.0)
                  ),
//              margin: EdgeInsets.all(8.0),
                  height: 80,
//                color: Colors.orange[300],
                  child: ListTile(
                    leading:Icon(Icons.location_on,color: Colors.blue,size: 35.0,),
                    title: TextField(
                      controller: cityname,
                      decoration: InputDecoration(

                        hintText: "Enter your current location",
                        fillColor: Colors.yellowAccent,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Card(
                elevation: 5.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  height: 80.0,
                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today,color: Colors.redAccent,size: 30.0,),

                      title: InkWell(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:<Widget>[
                              Text(startdate==null?"Start Trip ":formater.format(startdate),style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 24.0,
                                  color: Colors.black
                              ),),
                              Text(stime.format(context),style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24.0,
                                color: Colors.black,fontStyle: FontStyle.italic,
                              ),),
                            ]),
                        onTap: ()=>showdate(context),
                      ),

                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Card(
                elevation: 6.0,
                child: Container(

                  height: 80.0,
                  decoration: BoxDecoration(
//                  color: Colors.pink,
                    color: Colors.teal,
                    borderRadius:BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today,color: Colors.redAccent,size: 30.0,),

                      title: InkWell(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:<Widget>[
                              Text(enddate==null?"End Trip ":formater.format(enddate),style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.0,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black

                              ),),
                              Text(etime.format(context),style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.0,
                                  color: Colors.black
                              ),),
                            ]),
                        onTap: ()=>showenddate(context),
                      ),

                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),

              Card(
                elevation: 5.0,
                child: Container(
                  height: 60.0,
                  decoration: BoxDecoration(

                    borderRadius:BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: RaisedButton(
                        color: Colors.amberAccent,
                        child: Text("Search",
                          style: TextStyle(fontSize: 24),),
                        onPressed: (){
                          Navigator.of(context).pushNamed("/displycars");

                        }//search button to fetch data from menu,
                    ),
                  ),
                ),

              ),
              Text("Latest Offers",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),),
              Card(
                elevation: 6.0,
                child: Container(
                  height: 200.0,
                  child: PageView(

                    children: <Widget>[
                      page1(),
                      page2(),
                      page3(),
                      //offers can be shown here

                    ],
                  ),
                ),
              )


            ],
          ),
        )
    );
  }
}

class page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: new NetworkImage("https://img.etimg.com/thumb/width-640,height-480,imgsize-240218,resizemode-1,msid-70770090/how-to-get-a-credit-card-if-you-dont-have-a-job.jpg"),
                fit: BoxFit.cover,
              ),
            ),

          ),
        ),
        Center(
          child: Text("35 % OFF RENT On Credit Card",
            style: TextStyle(fontSize: 25,
                color: Colors.green),),
        ),
      ],
    );
  }
}
class page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm-plrYM_CDpvJlyt-Xd8_yy0lsAp1miJPPMFA-PfaPKJvJbs0bQ&s"),
                fit: BoxFit.cover,

              ),


//




            ),
          ),
        ),
        Center(child: Text("20 % offer on Paypal",
          style: TextStyle(fontSize: 34.0,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent),)),
      ],
    );
  }
}class page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: new NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRR1eqL_jmV7WP03XmZkgkeLYu7dg9ciwO5ZrP2nVlzn0aWDNwq&s"),
                  fit: BoxFit.cover,
                )

//

            ),
          ),
        ),
        Center(child: Text("12.5 % offer on Physical Deal!",
          style: TextStyle(fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.pink),)),
      ],
    );
  }
}
//sign in

class signin extends StatefulWidget {
  @override
  _signinState createState() => _signinState();
}

class _signinState extends State<signin> {

  final GlobalKey<FormState> formkey=GlobalKey<FormState>();

  String email;
  String password;
  auth authservice;
  bool validated(){

    if(formkey.currentState.validate())
    {
      formkey.currentState.save();
      return true;
    }
    return false;
  }







  Widget build(BuildContext context) {
    return loading==true?load():Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                return SignUp();
              }));
            },
          ),
          Center(child: Text("Register",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),),)
        ],
      ),
      body:Center(
        child: ListView(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0,),

            Text("Welcome to V Rent !",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                fontSize: 22.0,
              ),textAlign: TextAlign.center,),
            SizedBox(height: 32.0,),
            Text("Sign in with Social Accoutn",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: ()async{
                    final auth at=provider.of(context).auth;
                    //                        formkey.currentState.save();
                    String userid=await at.signinwithgoogle();

                    print(userid.toString());
                    if(userid!=null)
                    {
                      setState(() {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_){

                          return homepage(userid);
                        }));
                      });
                    }

                    else{
                      print("can not sign in ");
                    }

                  },
                  child: Container(

                      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      height: 75.0,
                      width: 90.0,
                      child:  DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/google-logo.png'),
                          ),
                        ),
                      )

                  ),
                ),
                RaisedButton(
                  child: Text("Sign in with google",style: TextStyle(fontSize: 18,color: Colors.black87),),
                  color: Colors.amber,
                  onPressed:() async{
                    final auth at=provider.of(context).auth;
//                        formkey.currentState.save();
                    String userid=await at.signinwithgoogle();

                    print(userid.toString());
                    if(userid!=null)
                    {
                      setState(() {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (_){

                          return homepage(userid);
                        }));
                      });
                    }
                    else{
                      return;
                      print("can not sign in ");
                    }

                  },

//                  onPressed: ()=>authservice.createuser(email,passord),
                )
              ],
            ),

            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",


                        ),
                        onSaved: (val)=>email=val,
                        validator: (value)=>value.isEmpty?'email cannot be empty':null,


                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",


                        ),
                        onSaved: (val)=>password=val,
                        validator: (value)=>value.isEmpty?'password cannot be empty':null,


                      ),
                      RaisedButton(
                        child: Text("Sign in",style: TextStyle(fontSize: 18,color: Colors.black87),),
                        color: Colors.amber,
                        onPressed:() async{
                          final auth at=provider.of(context).auth;
                          if(validated())
                          {


//                        formkey.currentState.save();
                            setState(() {
                              loading=true;
                            });

                            String userid=await at.signinwithemailandpassword(email, password);

                            print(userid.toString());
                            if(userid!=null)
                            {
                              setState(() {
                                loading=false;

                                Navigator.of(context).push(MaterialPageRoute(builder: (_){

                                  return homepage(userid);
                                }));
                              });
                            }
                            else{
                              setState(() {
                                return Fluttertoast.showToast(msg: "user email or password may not correct please enter the correct details",toastLength: Toast.LENGTH_LONG);

                              });
                              print("can not sign in ");
                            }
                          }
                        },

//                  onPressed: ()=>authservice.createuser(email,passord),
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File storepicture;
  Future<void> addUser(String name,String email,String phone,String imageurl,String userid) async{
    await Firestore.instance.collection("UserData").add({
      'name':name,
      'email':email,
      'phone':phone,
      'image':imageurl,
      'user':userid
    });
  }

  Future takePhotoFromGalary() async{
    File galaryphoto=await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      storepicture=galaryphoto;
    });
  }
  Future takePhotoByCamera() async{
    File imagefromcamera=await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 600,maxHeight: 600,);
    setState(() {
      storepicture=imagefromcamera;
    });
  }


  final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  String email;
  String password;
  bool validated(){

    if(formkey.currentState.validate())
    {
      formkey.currentState.save();
      return true;
    }
    return false;
  }
  String fullname;
  //phone authenticaton method
  String phonenumber;
  String smscode;
  String verificaionid;
  Future<void> verifyphonenumber() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout=(String verid){
      this.verificaionid=verid;
    };
    final PhoneCodeSent smsSent=(String smsid,[int forceresend]){
      this.verificaionid=smsid;
    };
    final PhoneVerificationCompleted vcompleted =(){

    } as PhoneVerificationCompleted;
    final PhoneVerificationFailed vfailed=(){

    } as PhoneVerificationFailed;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phonenumber,
        timeout: const Duration(seconds: 10),
        verificationCompleted: vcompleted,
        verificationFailed: vfailed,
        codeSent:smsSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }
  Widget build(BuildContext context) {

    return loading?load(): Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                return signin();
              }));
            },
          ),
          Center(child: Text("Log in",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),),)
        ],
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[
            Text("Create an account.",
              style: TextStyle(
                  fontSize: 22.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Colors.black
              ),
              textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Card(
                  elevation: 3,
                  child: Container(
                      height: 100.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 1),
                      ),
                      child: storepicture!=null?Image.file(storepicture,fit: BoxFit.cover,):Icon(Icons.photo,size: 35.0,)
//                color: Colors.grey,
                  ),
                ),
                Column(
                  children: <Widget>[
                    RaisedButton.icon(
                      onPressed:takePhotoByCamera,
                      icon: Icon(Icons.camera_alt),
                      label: Text("Upload Your Picture",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0
                        ),
                      ),
                    ),
                    RaisedButton.icon(

                      onPressed:takePhotoFromGalary,
                      icon: Icon(Icons.photo_library),
                      label: Text("photo from galary",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.5),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter The Full Name",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue,width: 1),
                            ),
                            filled: true,
                            contentPadding:
                            EdgeInsets.all(15.0
                            )
                        ),
                        onSaved: (val)=>fullname=val,
                        validator: (value)=>value.isEmpty?'Name cannot be empty':null,
                      ),SizedBox(height: 5.0,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter The Phone Number",
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                          filled: true,
                          contentPadding:
                          EdgeInsets.all(12.0),
                        ),
                        keyboardType:TextInputType.phone,
                        onSaved: (val)=>phonenumber=val,
                        validator: (value)=>value.isEmpty?'phon number cannot be empty':null,
                      ),SizedBox(height: 5.0,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Email",
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                          filled: true,
                          contentPadding:
                          EdgeInsets.all(12.0),
                        ),
                        onSaved: (val)=>email=val,
                        validator: (value)=>value.isEmpty?'email cannot be empty':null,
                      ),SizedBox(height: 4.0,),
                      TextFormField(
                        obscureText:true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                          filled: true,
                          contentPadding:
                          EdgeInsets.all(12.0),
                        ),
                        onSaved: (val)=>password=val,
                        validator: (value)=>value.isEmpty?'password cannot be empty':null,
                      ),SizedBox(height: 5.0,),
                      RaisedButton(
                        child: Text("Sign up",style: TextStyle(fontSize: 18,color: Colors.black87),),
                        color: Colors.amber,
                        onPressed:() async{
                          final auth at=provider.of(context).auth;
                          if(validated())
                          {
                            String userid=await at.createuserwithemailandpassword(email, password);
                            print(userid.toString());
                            if(userid!=null)
                            {
                              if(storepicture!=null){
                                StorageReference reference=FirebaseStorage.instance.ref().child("UsersPhoto");
                                StorageUploadTask uploadtask=reference.child("Image${Random().nextInt(1000).toString()}"+".jpg").putFile(storepicture);
                                String imagelocation=await (await uploadtask.onComplete).ref.getDownloadURL();
//                                addUser(fullname, email,phonenumber, imagelocation, userid);
                                await Firestore.instance.collection("UserData").document(userid).setData({
                                  'name':fullname,
                                  'email':email,
                                  'phone':phonenumber,
                                  'image':imagelocation,
                                  'user':userid,
                                  'license1':null,
                                  'license2':null
                                });
                                setState(() {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                    return signin();
                                  }));
                                });
                              }}
                            else{
                              print("can not sign up ");
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


