import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vrent/authentication/Auth.dart';
import 'package:vrent/authentication/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vrent/product/vehicles.dart';

class catagoryDetails extends StatefulWidget{
//  String name;
//  String url;

  @override
  _catagoryDetailsState createState() => _catagoryDetailsState();
}

class _catagoryDetailsState extends State<catagoryDetails> {
     final List item_list=[
    {"name":"Economy","url":"images/img1.jpg","id":" "},
    {"name":"Compat","url":"images/img2.jpg","id":" "},
    {"name":"Intermediate","url":"images/img3.jpg","id":" "},
    {"name":"Full Size","url":"images/img4.jpg","id":" "},
    {"name":"Premium","url":"images/img5.jpg","id":" "},
    {"name":"Mid Size","url":"images/img6.jpg","id":" "},
    {"name":"Minivan","url":"images/img7.jpg","id":" "},
    {"name":"Convertible","url":"images/img8.jpg","id":" "}
  ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Catagories"),
        ),
        body:Padding(
          padding: EdgeInsets.all(7.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.9,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context,int index){
                return catagory(
                  prodname: item_list[index]["name"],
                  imagUrl: item_list[index]["url"],
//                id:item_list[index]["id"],
                );
              },
            itemCount: item_list.length,
          ),
        ),

      );
    }
}
class catagory extends StatefulWidget {
  final prodname;
  final imagUrl;
  final id;

  const catagory({ this.prodname, this.imagUrl, this.id});
  @override
  _catagoryState createState() => _catagoryState();
}

class _catagoryState extends State<catagory> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(

          tag: widget.prodname,
          child:Material(

            child: InkWell(

              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return cardatailsBasedOnCatagory(widget.prodname);
                }));
//                return Fluttertoast.showToast(msg: "the Detail for this particular category is not implemented .",toastLength: Toast.LENGTH_LONG);
              },
              child: GridTile(
                header: Text("Type"),
                footer: Container(
                  height: 30.0,
                  color: Colors.pinkAccent[200],
                    child: Text(widget.prodname,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 18
                    ),textAlign: TextAlign.center,)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.tealAccent,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(widget.imagUrl)
                    )
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class cardatailsBasedOnCatagory extends StatefulWidget {
  cardatailsBasedOnCatagory(this.prodname);
  String prodname;

  @override
  _cardatailsBasedOnCatagoryState createState() => _cardatailsBasedOnCatagoryState();
}

class _cardatailsBasedOnCatagoryState extends State<cardatailsBasedOnCatagory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Cars"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("carsData").where('typeofcar',isEqualTo: widget.prodname).snapshots(),
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
      ),
    );
  }
}

