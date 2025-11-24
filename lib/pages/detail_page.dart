import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Map product;
  const DetailPage({super.key, required this.product});

  openWa(String phone, String namaProduk) async {

    if(phone.isEmpty){
      return;
    }

    final text = Uri.encodeComponent(
      "Halo, saya ingin membeli *$namaProduk*"
    );

    final url = Uri.parse("https://wa.me/$phone?text=$text");

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication
    );
  }

  @override
  Widget build(BuildContext context) {

    final String image = product['gambar'] ?? "";
    final String nama = product['nama_produk'] ?? "-";
    final String harga = product['harga'] ?? "0";
    final String desk = product['deskripsi'] ?? "-";

    // backend kamu bukan "no_wa" tapi "kontak"
    final String noWa = product['toko']?['kontak']?.toString() ?? "";

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(nama),
        elevation: 0,
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        height: 70,
        child: ElevatedButton(
          onPressed: noWa.isEmpty ? null : (){
            openWa(noWa, nama);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            "Beli Via WhatsApp",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 4),

            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 260,
                child: image.isEmpty
                    ? Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Text("Tidak ada gambar")),
                )
                    : Image.network(image, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            /// PRODUCT BOX
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Rp $harga",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const Divider(height: 30),

                  const Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    desk,
                    style: const TextStyle(fontSize: 15),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 120),

          ],
        ),
      ),

    );
  }
}
