import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_store_page.dart';
import 'add_product_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  Map? store;
  List products = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    setState(()=> loading = true);

    final res = await ApiService.getMyStore();

    if(res["success"] == true){
      store = res["data"];

      if(store != null){
        final prods = await ApiService.getMyProducts();
        products = prods;
      }
    }

    setState(()=> loading = false);
  }

  deleteStore() async {
    final ok = await ApiService.deleteStore();
    if(ok["success"] == true){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Toko dihapus!"))
      );
      load();
    }
  }

  @override
  Widget build(BuildContext context) {

    if(loading){
      return const Center(child: CircularProgressIndicator());
    }

    if(store == null){
      return const Center(child: Text("Anda belum memiliki toko"));
    }

    return RefreshIndicator(
      onRefresh: () async => load(),
      child: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          if(store!["gambar"] != null)
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(store!["gambar"])
                ),
              ),
            ),

          const SizedBox(height: 16),

          Text(store!["nama_toko"],
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),

          Text(store!["deskripsi"] ?? "-"),

          Text("WA : ${store!["kontak"]}"),
          Text("Alamat : ${store!["alamat"]}"),

          const SizedBox(height: 15),

          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditStorePage(store: store!)),
                  ).then((value)=>load());
                },
                child: const Text("Edit Toko"),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: deleteStore,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Hapus"),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Produk Saya",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if(products.isEmpty)
            const Text("Belum ada produk"),

          ...products.map((p){
            return ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: Text(p["nama_produk"]),
              subtitle: Text("Rp ${p["harga"]}"),
            );
          }).toList()

        ],
      ),
    );
  }
}
