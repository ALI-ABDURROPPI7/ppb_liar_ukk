import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  double opacity = 0;

  @override
  void initState() {
    super.initState();

    // animasi fade
    Future.delayed(const Duration(milliseconds: 300), (){
      setState(() => opacity = 1);
    });

    // pindah halaman otomatis
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff4F46E5),
              Color(0xff6D28D9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Fade animation
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: opacity,
              child: const Icon(
                Icons.store_mall_directory_rounded,
                color: Colors.white,
                size: 85,
              ),
            ),

            const SizedBox(height: 20),

            AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: opacity,
              child: const Text(
                "Marketplace Sekolah",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 35),

            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),

          ],
        ),
      ),
    );
  }
}
