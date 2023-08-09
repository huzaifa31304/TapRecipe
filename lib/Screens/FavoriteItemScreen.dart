// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tap_recipe/Screens/webpage.dart';
//
// class FavoriteItemScreen extends StatefulWidget {
//   @override
//   _FavoriteItemScreenState createState() => _FavoriteItemScreenState();
// }
//
// class _FavoriteItemScreenState extends State<FavoriteItemScreen> {
//   late FirebaseFirestore _firestore;
//   late CollectionReference<Map<String, dynamic>> _favoritesCollection;
//
//   @override
//   void initState() {
//     super.initState();
//     _firestore = FirebaseFirestore.instance;
//     _favoritesCollection = _firestore
//         .collection('favorite')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('items');
//   }
//   Future<void> deleteFavorite(String itemId) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         // User is not logged in
//         return;
//       }
//
//       final userId = user.uid;
//       final document = _firestore
//           .collection('favorite')
//           .doc(userId)
//           .collection('items')
//           .doc(itemId);
//
//       await document.delete();
//     } catch (e) {
//       print('Error deleting favorite: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Favorite Items'),
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: _favoritesCollection.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           final data = snapshot.data!.docs;
//
//           if (data.isEmpty) {
//             return Center(
//               child: Text('No favorite items found.'),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final item = data[index].data();
//
//               return ListTile(
//                 title: Text(item['label']),
//                 subtitle: Text(item['source']),
//                 leading: Image.network(item['image']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WebPage(url: item['url']),
//                     ),
//                   );
//                 },
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     deleteFavorite(data[index].id);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
