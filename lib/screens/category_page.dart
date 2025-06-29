import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_detail_page.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  static void navigateToCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCategoryHeader(),
          Expanded(child: _buildBookList()),
        ],
      ),
    );
  }

  // Widget deskripsi kategori di atas list
  Widget _buildCategoryHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori Bisnis',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Temukan koleksi buku bisnis terbaik dengan berbagai pilihan menarik untuk menambah wawasan Anda.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Widget list buku yang diambil dari Firestore
  Widget _buildBookList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('books')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Terjadi kesalahan'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookDocs = snapshot.data!.docs;

        if (bookDocs.isEmpty) {
          return const Center(child: Text('Tidak ada buku di kategori ini.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: bookDocs.length,
          itemBuilder: (context, index) {
            final data = bookDocs[index].data() as Map<String, dynamic>;
            return _buildBookCard(context, data);
          },
        );
      },
    );
  }

  // Widget untuk satu kartu buku
  Widget _buildBookCard(BuildContext context, Map<String, dynamic> data) {
    final title = data['title'] ?? 'Tanpa Judul';
    final author = data['author'] ?? 'Tanpa Penulis';
    final imageUrl = data['cover_url'] ?? '';
    final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = data['reviews'] ?? 0;
    final price = data['price'] ?? 0;
    final oldPrice = data['old_price'];
    final isOnSale = oldPrice != null && oldPrice > price;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailPage(bookData: data)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildCoverImage(imageUrl, isOnSale),
            const SizedBox(width: 12),
            Expanded(child: _buildBookInfo(title, author, rating, reviews, price, oldPrice)),
          ],
        ),
      ),
    );
  }

  // Gambar cover dan badge SALE
  Widget _buildCoverImage(String imageUrl, bool isOnSale) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 60,
                  height: 90,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                ),
        ),
        if (isOnSale)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Sale',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
      ],
    );
  }

  // Info judul, penulis, rating, dan harga
  Widget _buildBookInfo(String title, String author, double rating, int reviews, int price, int? oldPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 4),
        Text(author, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.star, size: 14, color: Colors.orange),
            const SizedBox(width: 4),
            Text('${rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(' ($reviews)', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              'Rp $price',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 14),
            ),
            if (oldPrice != null && oldPrice > price) ...[
              const SizedBox(width: 6),
              Text(
                'Rp $oldPrice',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
