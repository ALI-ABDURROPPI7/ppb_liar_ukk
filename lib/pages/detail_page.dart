import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Map product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    final String image = product['gambar'] ?? "";
    final String nama = product['nama_produk'] ?? "-";
    final String harga = product['harga'] ?? "0";
    final String desk = product['deskripsi'] ?? "-";

    final String noWa = product['toko']?['no_wa'] ?? "";   // <-- ambil dari API

    return Scaffold(
      appBar: AppBar(
        title: Text(nama),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ============ GAMBAR PRODUK ==============
            Container(
              width: double.infinity,
              height: 240,
              color: Colors.grey.shade200,
              child: image.isEmpty
                  ? const Center(child: Text("Tidak ada gambar"))
                  : Image.network(image, fit: BoxFit.cover),
            ),

            const SizedBox(height: 20),

            Text(nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
            ),

            Text(
              "Rp $harga",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              desk,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: noWa.isEmpty ? null : () async {

                  final msg = Uri.encodeComponent(
                      "Halo, saya tertarik dengan produk $nama"
                  );

                  final url = Uri.parse("https://wa.me/$noWa?text=$msg");

                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );

                },
                child: const Text("Beli via WhatsApp"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
