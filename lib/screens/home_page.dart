import 'package:flutter/material.dart';
// Pastikan Anda memiliki file category_page.dart atau hapus/sesuaikan impor ini
import 'category_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                StatCard(
                  title: '1000+',
                  subtitle: 'Buku Tersedia',
                  icon: Icons.trending_up,
                  color: Colors.blue,
                ),
                StatCard(
                  title: '50k+',
                  subtitle: 'Pembaca Puas',
                  icon: Icons.emoji_events,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ), // Sedikit ditambah agar tidak terlalu dekat
            const _CategoryHeader(),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              // --- PERUBAHAN DI SINI ---
              // Dinaikkan dari 0.75 menjadi 0.9 untuk membuat kotak lebih pendek.
              // Anda bisa coba angka 1.0 untuk membuatnya persegi.
              childAspectRatio: 0.9,
              children: [
                CategoryCard(
                  icon: Icons.menu_book,
                  label: "Fiksi",
                  count: "156 buku",
                  color: Color(0xFFEAF1FF),
                  onTap: CategoryPage.navigateToCategory,
                ),
                CategoryCard(
                  icon: Icons.book_online,
                  label: "Non-Fiksi",
                  count: "89 buku",
                  color: Color(0xFFE3FAF1),
                  onTap: CategoryPage.navigateToCategory,
                ),
                CategoryCard(
                  icon: Icons.business_center,
                  label: "Bisnis",
                  count: "134 buku",
                  color: Color(0xFFF3ECFC),
                  onTap: CategoryPage.navigateToCategory,
                ),
                CategoryCard(
                  icon: Icons.computer,
                  label: "Teknologi",
                  count: "98 buku",
                  color: Color(0xFFFFF3DA),
                  onTap: CategoryPage.navigateToCategory,
                ),
                CategoryCard(
                  icon: Icons.science,
                  label: "Sains",
                  count: "76 buku",
                  color: Color(0xFFEAFBF9),
                  onTap: CategoryPage.navigateToCategory,
                ),
                CategoryCard(
                  icon: Icons.account_balance,
                  label: "Sejarah",
                  count: "67 buku",
                  color: Color(0xFFFFF3D7),
                  onTap: CategoryPage.navigateToCategory,
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              "Buku Pilihan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final books = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final data = books[index].data() as Map<String, dynamic>;
                    return BookCard(book: data, bookId: books[index].id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(Icons.menu, color: Colors.black87),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BookStore',
            style: TextStyle(
              color: Color(0xFF8B4513),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Temukan buku favoritmu',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: const [
        Icon(Icons.search, color: Colors.black87),
        SizedBox(width: 16),
        Icon(Icons.shopping_cart_outlined, color: Colors.black87),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB05727),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Temukan Buku Favoritmu",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Koleksi lengkap buku terbaru dengan harga terbaik",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Cari judul, penulis, atau kategori",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Kartu Statistik
class StatCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(subtitle),
        ],
      ),
    );
  }
}

// Header Kategori
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Kategori Populer",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text("Lihat Semua", style: TextStyle(color: Color(0xFF8B4513))),
      ],
    );
  }
}

// Kartu Kategori
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color color;
  final void Function(BuildContext context, String label) onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context, label),
      child: Container(
        padding: const EdgeInsets.all(
          8,
        ), // Mengubah padding agar lebih seimbang
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          // --- PERUBAHAN DI SINI ---
          mainAxisAlignment:
              MainAxisAlignment.center, // Menengahkan konten secara vertikal
          crossAxisAlignment:
              CrossAxisAlignment.center, // Menengahkan konten secara horizontal
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color,
              child: Icon(icon, size: 20, color: Colors.black),
            ),
            const SizedBox(height: 8), // Mengurangi jarak
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Menambahkan text align center
            ),
            const SizedBox(
              height: 4,
            ), // Menambah sedikit jarak agar tidak terlalu rapat
            Text(
              count,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
