import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {

  String userid;
  Profile(this.userid);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selectedindex=0;
  File fimage,bimage;
  String fimageurl;
//  String bimgeurl;

  String bimageurl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile "),

      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index){
          setState(() {
            selectedindex=index;
          });
        },
        currentIndex: selectedindex,
         items: [
           BottomNavigationBarItem(
             icon: Icon(Icons.person),
             title: Text("Profile")
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.settings),
             title: Text("Documents")
           )
         ],
      ),
      body: selectedindex==0?StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection("UserData").document(widget.userid).snapshots(),
        builder: (context,snapshot){
          var userDocument=snapshot.data;
          if(!snapshot.hasData)
            return CircularProgressIndicator();
          else{
          return  Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  color: Colors.brown,
                ),
                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         SizedBox(height: 70,),
                         Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,width: 3),
                              borderRadius: BorderRadius.circular(80),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(userDocument['image']),
                              ),
                              color: Colors.white
                          ),
                ),
                         SizedBox(height: 20,),
                         Divider(),
                         Text(" Name : ${userDocument["name"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                         SizedBox(height: 30,),
                         ListTile(
                           leading: Icon(Icons.email,color: Colors.blue,),
                           title: Text("${userDocument['email']}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                           trailing: Text("Edit"),
                         ),
                         Divider(),
                         SizedBox(height:20),
                          ListTile(
                            leading: Icon(Icons.phone,color: Colors.black,),
                            title: Text("${userDocument['phone']}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                            trailing: Text("Edit"),
                          ),Divider(),
                         SizedBox(height: 50,),
                         Text("Location of the user"),
                       ],
                     ),
                   ),
              ],
            )
          ;}
        },
      ):StreamBuilder(
          stream: Firestore.instance.collection("UserData").document(widget.userid).snapshots(),
          builder: (context, snapshot) {
            var userlicensedocument=snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(children: <Widget>[
              SizedBox(height: 10,),
              Text("Provid Information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                SizedBox(height: 10,),
                Text("Upload License",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                SizedBox(height: 8,),
                Text("a. Upload clear front and back image of the original driving license . ",style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(height: 8,),
                Text(" b. photo ,license number and date of birth should be clearly visible. ",style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8,),
                Text("c. valid 4 wheeler license is to drice the car and valid 2 wheeler license to drive the bike.",style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8,),
                Text("d. Once the license is linked to your account it can not be modified",style: TextStyle(fontWeight: FontWeight.w500)),

                SizedBox(height: 10,),
                Container(height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(10),
                    border:Border.all(color: Colors.black,width: 2,style: BorderStyle.solid),
                  ),
                  child:userlicensedocument['license1']==null?InkWell(
                    onTap: ()async{
                      File pickimge=await ImagePicker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        fimage=pickimge;
                      });
                      StorageReference reference=FirebaseStorage.instance.ref().child("Photo");
                      StorageUploadTask uploadtask=reference.child("Image${Random().nextInt(100000).toString()}"+".jpg").putFile(fimage);
                      fimageurl=await (await uploadtask.onComplete).ref.getDownloadURL();
                    },
                    child: fimage!=null?Image.file(fimage,fit: BoxFit.cover,):Center(child: Text("Upload front page",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  ):Image.network(userlicensedocument['license1'],fit: BoxFit.cover,),
                ),
                SizedBox(height: 10,),
                Container(height: 200,
                width: double.infinity,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(10),
                  border:Border.all(color: Colors.black,width: 2,style: BorderStyle.solid),
                ),
                child:userlicensedocument['license2']==null?InkWell(
                  onTap: ()async{
                    File pickimge=await ImagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      bimage=pickimge;
                    });
                    StorageReference reference=FirebaseStorage.instance.ref().child("Photo");
                    StorageUploadTask uploadtask=reference.child("Image${Random().nextInt(100000).toString()}"+".jpg").putFile(bimage);
                    bimageurl=await (await uploadtask.onComplete).ref.getDownloadURL();
                  },
                  child: bimage!=null?Image.file(bimage,fit: BoxFit.cover,):Center(child: Text("Upload front page",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                ):Image.network(userlicensedocument['license2'],fit: BoxFit.cover,),
                ),
                SizedBox(height: 10,),
                Card(
                  child: GestureDetector(
                    onTap: ()async{
                      if(fimageurl!=null&&bimageurl!=null)
                      {
                        FirebaseUser user=await FirebaseAuth.instance.currentUser();
                        await Firestore.instance.collection("UserData").document(user.uid).updateData({
                          'license1':fimageurl,
                          'license2':bimageurl,
                        });
                        Fluttertoast.showToast(msg: "license uploaded sccessfully .",toastLength: Toast.LENGTH_LONG);

                      }else{
                        Fluttertoast.showToast(msg: "please upload your license",toastLength: Toast.LENGTH_LONG);
                      }
                    },
                    child: Container(
                      child: Text("Upload License",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic
                        ),),
                      height: 55.0,
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                )
              ],),
            );
          }
        ),
    );
  }

}
