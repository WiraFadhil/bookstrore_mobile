import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorit")),
      body: user == null
          ? const Center(child: Text("Belum login"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final books = snapshot.data!.docs;
                if (books.isEmpty) return const Center(child: Text("Belum ada buku favorit"));

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: books.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return BookCard(book: data, bookId: doc.id);
                  }).toList(),
                );
              },
            ),
    );
  }
}
