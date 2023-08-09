import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tap_recipe/Screens/webpage.dart';
import 'package:http/http.dart' as http ;
import '../Models/model.dart';


class SearchPage extends StatefulWidget {
  String? search;
  SearchPage({this.search});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<Model> list = <Model>[];
  String? text;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getApiData(search)async{
    final url= "https://api.edamam.com/search?q=$search&app_id=61e8bad9&app_key=6904e1bdafc40d222ab62283e396722d&from=0&to=100&calories=591-722&health=alcohol-free";

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
    getApiData(widget.search);
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              // GridView.builder(
              //     physics: ScrollPhysics() ,
              //     shrinkWrap: true,
              //     primary: true,
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2,
              //         crossAxisSpacing: 5,
              //         mainAxisSpacing: 5
              //     ),
              //     itemCount: list.length,
              //     itemBuilder: (context,i){
              //       final x= list[i];
              //       return InkWell(
              //         onTap: (){
              //           Navigator.push(context, MaterialPageRoute(
              //               builder: (context)=>WebPage(url: x.url)));
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //               image: DecorationImage(
              //                   image: NetworkImage(x.image.toString())
              //               )
              //           ),
              //           child: Column(
              //             children: [
              //               Container(
              //                 padding: EdgeInsets.all(4),
              //                 color: Colors.grey.withOpacity(0.4),
              //                 child: Text(x.label.toString()),
              //               )
              //             ],
              //           ),
              //         ),
              //       );
              //     })

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
                          top: 20,
                          right: 0.1,
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
