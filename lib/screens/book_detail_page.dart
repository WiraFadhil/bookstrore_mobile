import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailPage extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookDetailPage({super.key, required this.bookData});

  // Fungsi untuk membuka WhatsApp
  void _launchWhatsApp(String phone, String message) async {
    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka WhatsApp';
    }
  }

  // Dialog untuk QRIS + tombol WA
  void _showQrisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Scan QRIS untuk Pembayaran'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  bookData['qris_image_url'],
                  height: 200,
                  errorBuilder: (_, __, ___) => const Icon(Icons.qr_code),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text('Hubungi Penjual'),
                  onPressed: () {
                    Navigator.pop(context);
                    _launchWhatsApp(
                      bookData['whatsapp_number'],
                      'Halo, saya ingin membeli buku "${bookData['title']}"',
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = bookData['title'] ?? 'Tanpa Judul';
    final author = bookData['author'] ?? 'Tidak diketahui';
    final description = bookData['description'] ?? 'Tidak ada deskripsi.';
    final imageUrl = bookData['cover_url'] ?? '';
    final qrisUrl = bookData['qris_image_url'] ?? '';
    final phone = bookData['whatsapp_number'] ?? '';
    final price = bookData['price']?.toString() ?? 'N/A';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            _buildCoverImage(imageUrl),
            const SizedBox(height: 16),
            _buildTitleAndAuthor(title, author),
            const SizedBox(height: 20),
            _buildTabs(),
            const SizedBox(height: 10),
            _buildInfoRow(),
            const SizedBox(height: 20),
            _buildDescription(description),
            if (qrisUrl.isNotEmpty && phone.isNotEmpty)
              _buildBuyButton(context, price),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 32),
          const Text(
            "Literature",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child:
          url.isNotEmpty
              ? Image.network(
                url,
                height: 150,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.image_not_supported),
              )
              : Container(
                height: 150,
                width: 110,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
    );
  }

  Widget _buildTitleAndAuthor(String title, String author) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "by $author",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("About Book", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoBox(label: "Pages", value: "${bookData['pages'] ?? '-'}"),
          InfoBox(label: "Cover", value: "${bookData['cover_type'] ?? '-'}"),
          InfoBox(label: "Year", value: "${bookData['year'] ?? '-'}"),
          InfoBox(label: "Lang", value: "${bookData['language'] ?? '-'}"),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, height: 1.4),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => _showQrisDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A73E8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Buy it Now for Rp$price",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const InfoBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
