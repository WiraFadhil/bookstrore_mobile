import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'book_detail_page.dart';

class BookCard extends StatefulWidget {
  final Map<String, dynamic> book;
  final String bookId;

  const BookCard({super.key, required this.book, required this.bookId});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  void checkFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(widget.bookId)
            .get();

    setState(() {
      isFavorite = doc.exists;
    });
  }

  void toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.bookId);

    if (isFavorite) {
      await favRef.delete();
    } else {
      await favRef.set(widget.book);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void goToPayment() async {
    final sellerPhone = widget.book['wa'] ?? '628123456789'; // default nomor
    final title = widget.book['title'] ?? '';
    final price = widget.book['price'] ?? '';
    final message = Uri.encodeFull(
      "Halo, saya tertarik membeli buku *$title* dengan harga Rp $price.",
    );

    final url = 'https://wa.me/$sellerPhone?text=$message';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal membuka WhatsApp")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(bookData: widget.book),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar buku
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  book['cover_url'] != null
                      ? Image.network(
                        book['cover_url'],
                        height: 120,
                        width: 80,
                        fit: BoxFit.cover,
                      )
                      : const Icon(Icons.book, size: 80),
            ),
            const SizedBox(width: 12),

            // Info buku
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'] ?? 'Judul tidak tersedia',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['author'] ?? 'Penulis tidak tersedia',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),

                  // ⭐ Rating
                  if (book['rating'] != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(book['rating'].toString()),
                      ],
                    ),
                  const SizedBox(height: 6),

                  Text(
                    "Rp ${book['price']?.toString() ?? '0'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),

            // Favorit
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
