import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Vehicles extends StatefulWidget {

  @override
  _VehiclesState createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("the place names which searched  for"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return addrecord();
            }),
            ),)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("carsData").snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          // ignore: missing_return
          if(!snapshot.hasData) return Text("Loading ......");

          return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return Card(
              margin: EdgeInsets.all(8.0),
              elevation: 5,
              child: Container(
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(

                        crossAxisAlignment: CrossAxisAlignment.start, // ignore: missing_return
                        children: <Widget>[
                           Text(snapshot.data.documents[index]["name"],
                            style: TextStyle(
                              fontSize: 20
                            ),),
                          SizedBox(height: 10.0,),

                              Row(
                                children: <Widget>[
                                  Text(snapshot.data.documents[index]["seat"],
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),),
                                  Text(" | "),
                                  Text(snapshot.data.documents[index]["color"],
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),),

                                ],
                              ),
                          SizedBox(height: 10.0,),

                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on,color: Colors.green,),
                              Text(snapshot.data.documents[index]["location"]),

                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Row(
                            children: <Widget>[
                              RaisedButton(

                                color: Colors.lightGreen,
                              onPressed: (){},
                                child: Text(snapshot.data.documents[index]["price"]),
                              ),

                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[

                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
//                              border: Border.all(color: Colors.li)
                            ),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(snapshot.data.documents[index]["image"]),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.green,
                            onPressed: ()async{
//                              DocumentSnapshot ds=snapshot.data.documents[index];
                              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                return carDetails(index);
                              }));
                            },
                            child: Text("Book Now",style: TextStyle(
                              color: Colors.white
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                ),

              ),
            );

      });

        },
      )


    );
  }
}
class addrecord extends StatefulWidget {
  @override
  _addrecordState createState() => _addrecordState();
}

class _addrecordState extends State<addrecord> {
  var dropdownvalue='Economy';

  Future<void> addcars(String name,String seat,String color,String location,String price ,String imageurl, String dropdownvalue)async{
    await Firestore.instance.collection("carsData").add({
      'name':name,
      'seat':seat,
      'color':color,
      'location':location,
      'price':price,
      'image':imageurl,
      'typeofcar':dropdownvalue
    });
  }
  Future<void> multiimagescars(String name,String seat,String color,String location,String price ,List<String> uploadimages)async{
    await Firestore.instance.collection("Test").add({
      'name':name,
      'seat':seat,
      'color':color,
      'location':location,
      'price':price,
      'image':uploadimages
    });
  }
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  bool validate(){
    if(_formkey.currentState.validate())
      {
        _formkey.currentState.save();
        return true;
      }
    return false;
  }
  String name;
  String seat,color,location,price,imageurl;
  File imagetoupload;
  List<String> uploadimages=[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add record here"),
      ),
      body: ListView(

        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter the Brand name",
                  ),
                  validator: (value)=>value.isEmpty?"name should not be empty":null,
                  onSaved: (value)=>name=value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Seaters",
                  ),
                  validator: (value)=>value.isEmpty?"Seater should not be empty":null,
                  onSaved: (value)=>seat=value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Color",
                  ),
                  validator: (value)=>value.isEmpty?"Color should not be empty":null,
                  onSaved: (value)=>color=value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Rental price per day",
                  ),
                  validator: (value)=>value.isEmpty?"Price should not be empty":null,
                  onSaved: (value)=>price=value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter location",
                  ),
                  validator: (value)=>value.isEmpty?"Location should not be empty":null,
                  onSaved: (value)=>location=value,
                ),
                SizedBox(height: 12,),
                DropdownButton(
                  value:dropdownvalue ,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 15,
                  style: TextStyle(color: Colors.teal),
                  underline: Container(
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                  onChanged: (String newvalue){
                    setState(() {
                      dropdownvalue=newvalue;
                    });
                  },
                  items: <String>["Economy",'Compat','Intermediate','full Size','Premium','Mid Size','Minivan','Convertible'].map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12,),
                RaisedButton(
                  color: Colors.green,
                  onPressed: ()async{
                    if(validate())
                      {

                            var selectimage=await ImagePicker.pickImage(source: ImageSource.gallery);
                            setState(() {
                              imagetoupload=selectimage;
                            });
                                  StorageReference storagereference=FirebaseStorage.instance.ref().child("CarsPhoto");
                                  StorageUploadTask task=storagereference.child(DateTime.now().toIso8601String()+'.jpg').putFile(imagetoupload);
                                  String imagelocation=await (await task.onComplete).ref.getDownloadURL();
//                                  String imagelocation=await storagereference.getDownloadURL();
                                  imageurl=imagelocation.toString();
                                  print(imageurl);
                                    addcars(name, seat, color, location, price, imagelocation,dropdownvalue);
                                    _formkey.currentState.reset();
                      }
                    else
                      {
                        Fluttertoast.showToast(msg: "Record can not be added", toastLength: Toast.LENGTH_LONG);
                      }
                  },
                  child: Text("Upload Now",
                  ),
                ),

                SizedBox(height: 12,),
                RaisedButton(
                  color: Colors.green,
                  onPressed: ()async{
                   if(validate())
                     {
                       List<Asset> images = List<Asset>();
                       Asset asset ;
                       List<String> uploadUrls = [];
                       images = await MultiImagePicker.pickImages(
                         enableCamera:true ,
                         selectedAssets:images,
                         maxImages: 20,
                       );

                       for(var index=0;index<images.length;index++){
                         asset=images[index];
                         // ignore: deprecated_member_use
                         ByteData byteData = await asset.requestOriginal();
                         List<int> imageData = byteData.buffer.asUint8List();
                         StorageReference ref = FirebaseStorage.instance.ref().child("Multipeimages");
                         StorageUploadTask uploadTask = ref.child(DateTime.now().toIso8601String()+'.jpg').putData(imageData);
                         final String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
                         uploadUrls.add(downloadUrl);

                       }
                       multiimagescars(name, seat, color, location, price, uploadUrls);
                       _formkey.currentState.reset();
                       // ignore: deprecated_member_us
//                    return await (await uploadTask.onComplete).ref.getDownloadURL();
                     }
                  },
                  child: Text("Upload with multiple images",
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
class carDetails extends StatefulWidget {

  int index;
  carDetails(this.index);
  @override
  _carDetailsState createState() => _carDetailsState();
}
class _carDetailsState extends State<carDetails> {
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(double amount,int phone,String email) async {//the phone number and email does not retrieved from firestore .  hint

    var options = {
      'key': 'rzp_test_aaLEUMz1kSdc4D',
      'amount': amount*100,
      'name': 'Vehicle Management System',
      'image': 'https://www.73lines.com/web/image/12427',
      'description': 'pay by Razorpay gateway',
      'prefill': {'contact':"${phone}", 'email':email},
      /*'external': {
        'wallets': ['paytm']
      }*/
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }
  double paidamount;
  DocumentSnapshot document;

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{

    String email;
    int phonenumber;
    DocumentReference docRef = await
    Firestore.instance.collection('gameLevels').document();
    print(docRef.documentID);
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection("BookedCars").add(
      {
        'userid':user.uid,
        'paidamount':paidamount,
        'cardata':document.documentID,
        'paymentid':response.paymentId,

      }
    );
//      phonenumber=int.parse(documentsnapshot.data['phone']);
//      email=documentsnapshot.data['email'];
//      Fluttertoast.showToast(msg: "${phonenumber}"+email,toastLength: Toast.LENGTH_LONG);
////      openCheckout(double.parse(snapshot.data.documents[widget.index]['price']),phonenumber,email);
//    });

    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Details"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("carsData").snapshots(),
        builder: (context, snapshot) {
          return ListView(
            children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 220.0,
                    width: double.infinity,
                    color: Colors.grey,
                      child: Image.network(snapshot.data.documents[widget.index]['image']),
//            child:ListView.builder(
//                itemCount:snapshot.data.documents[widget.index]['image'].length,
////                itemCount: int.parse(snapshot.data.documents[widget.index]['image'].length),
//                itemBuilder: (context,index){
//              return  Image.network(snapshot.data.documents[widget.index]['image'][index],fit: BoxFit.cover,);
//            })
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Icon(Icons.person,size: 30,),
                            Text(snapshot.data.documents[widget.index]["seat"]+" Seater",style: TextStyle(
                                fontSize: 16
                            ),),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.ac_unit,size: 30,),
                            Text("Air Conditoning",style: TextStyle(
                                fontSize: 16
                            ),),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.card_travel,size: 30,),
                            Text("Tow Bags",style: TextStyle(
                                fontSize: 16
                            ),),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.directions_car,size: 30,),
                            Text("4 Doors",style: TextStyle(
                                fontSize: 16
                            ),),
                          ],
                        )
                      ],
                    ),
                  ),
                    Center(child:Text(snapshot.data.documents[widget.index]['name'],style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.green
                          ),),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center ,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star_border),
                            Icon(Icons.star_border),
                              Text("(3)"),
                        ],
                      ),
                  SizedBox(height: 12.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text("Start trip"),
                          Text("15/jan/2020",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text("End trip"),
                          Text("22/jan/2020",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                        ],
                      )
                    ],),
                  ),
                  SizedBox(height: 12.0,),
                  Text("Pick Up & Return",textAlign: TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                  ListTile(leading: Icon(Icons.location_on,size: 35,),
                  title: Text(snapshot.data.documents[widget.index]["location"]),),
                  SizedBox(height: 12.0,),
                  Text("Cancellation Policy",textAlign: TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                  ListTile(leading: Icon(Icons.reply_all,size: 35,),
                  title: Text("Free cancellation",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                  subtitle: Text("Full Refund before 00:00:00"),),
                  SizedBox(height: 12.0,),
                  Text("Hosted By",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person),),
                    title: Text("Service Provider Name"),
                    subtitle: Text("Typically responds in 10 min"),
                  ),
                  SizedBox(height: 12.0,),
                  Text("Description",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                  Text("Grea comfortable car for short and long trips , heated seates ,back up camera,leather,Aux and USB input less consume gas, run smoothly ."),

                  Card(
                   child: GestureDetector(
                     onTap: ()async{
                       String email;
                       int phonenumber;
                       FirebaseUser user=await FirebaseAuth.instance.currentUser();
                       Firestore.instance.collection("UserData").document(user.uid).get().then((documentsnapshot){
                         phonenumber=int.parse(documentsnapshot.data['phone']);
                         email=documentsnapshot.data['email'];
                         document=snapshot.data.documents[widget.index];
                         paidamount=double.parse(snapshot.data.documents[widget.index]['price']);
                         Fluttertoast.showToast(msg: "${phonenumber}"+email,toastLength: Toast.LENGTH_LONG);
                         openCheckout(double.parse(snapshot.data.documents[widget.index]['price']),phonenumber,email);
                       });
                       Fluttertoast.showToast(msg: document.documentID,toastLength: Toast.LENGTH_LONG);

                     },
                     child: Container(
                       child: Text("Continue Booking",
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
                         color: Colors.pinkAccent,
                         borderRadius: BorderRadius.circular(15.0),
                       ),
                     ),
                   ),
                  )
                ],
              ),
            ),
          ]);
        }
      )
    );
  }
}

