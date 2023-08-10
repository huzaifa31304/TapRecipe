import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http ;
import 'package:tap_recipe/Models/model.dart';
import 'package:tap_recipe/Screens/search_page.dart';
import 'package:tap_recipe/Screens/webpage.dart';
import 'package:tap_recipe/Screens/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FavoriteItemScreen.dart';
class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {

  List<Model> list = <Model>[];
  String? text;
  late FirebaseFirestore _firestore;
  final url= "";

  getApiData()async{
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e){
      Model model= Model(
          url: e['recipe']['url'],
          image: e['recipe']['image'],
          source: e['recipe']['source'],
          label: e['recipe']['label'],
      );
      setState(() {
        list.add(model);
      });
    }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore = FirebaseFirestore.instance;
    getApiData();
  }

  //logout method
  void logUserOut(){
    FirebaseAuth.instance.signOut();
  }
  Future<void> saveFavorite(Model model) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // User is not logged in
        return;
      }

      final userId = user.uid;
      final document = _firestore.collection('favorite').doc(userId);

      final favoritesCollection = document.collection('items');
      final newFavoriteDoc = favoritesCollection.doc();

      await newFavoriteDoc.set({
        'id': newFavoriteDoc.id,
        'url': model.url,
        'image': model.image,
        'source': model.source,
        'label': model.label,
        'isFavorite': model.isFavorite,
      });
    } catch (e) {
      print('Error saving favorite: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () { Navigator.of(context).push
                  (
                    MaterialPageRoute(
                      builder: (context) => Camera_Page(),
                    )
                );
                },
                icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  size: 33,
                )
            ),
            // IconButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) =>saved_page(),
            //       ),
            //     );
            //   },
            //   icon: Icon(
            //     Icons.favorite,
            //     color: Colors.white,
            //   ),
            // ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Menu",
                style: GoogleFonts.dancingScript(
                  fontSize: 28,
                    color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        backgroundColor: Colors.black87,
        ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (v){
                  text = v;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context)=>SearchPage(
                                search: text,
                              )));
                    },
                    icon:Icon(Icons.search),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  fillColor: Colors.grey[400],
                  filled: true
                ),
              ),

              SizedBox(height: 15),
              

              GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebPage(url: x.url),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(x.image.toString()),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                color: Colors.grey.withOpacity(0.6),
                                child: Text(x.label.toString()),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 0.2,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                x.isFavorite = !x.isFavorite;
                              });

                              saveFavorite(x);
                            },
                            icon: Icon(
                              x.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,

                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
