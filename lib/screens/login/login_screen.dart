import 'package:flutter/material.dart';
import '/../constants/colors.dart';
import '/../widgets/custom_textfield.dart'; // Komponen input yang kamu buat sendiri
import '../daftar/register.screen.dart';    // Halaman daftar

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background halaman
      backgroundColor: AppColors.background,

      // Biar konten bisa di-scroll kalo layar kecil
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: Column(
            children: [

              // Logo + Nama Aplikasi
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.book, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 12),
              const Text(
                "BookStore",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text("Selamat datang kembali!"),

              const SizedBox(height: 30),

              // Kartu formulir login
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Judul
                    const Text(
                      "Masuk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text("Masuk ke akun Anda untuk melanjutkan"),
                    const SizedBox(height: 16),

                    // Input email
                    const CustomTextField(
                      hint: "nama@email.com",
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),

                    // Input password
                    const CustomTextField(
                      hint: "Password Anda",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 8),

                    // Tombol "Lupa password?"
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Tambahkan aksi lupa password
                        },
                        child: const Text("Lupa password?"),
                      ),
                    ),

                    // Tombol Masuk
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Tambahkan logika login
                        },
                        child: const Text("Masuk"),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tautan ke halaman daftar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun?"),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () {
                            // Pindah ke halaman daftar
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text("Daftar Sekarang"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Catatan demo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text.rich(
                  TextSpan(
                    text: "Demo: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "Gunakan email dan password apa saja untuk masuk",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
