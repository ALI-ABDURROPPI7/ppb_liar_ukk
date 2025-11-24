import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_store_page.dart';
import 'add_store_page.dart';
import 'add_product_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  Map? store;
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {

    setState(()=> loading = true);

    final res = await ApiService.getMyStore();

    if(res["success"] == true){
      store = res["data"];

      if(store != null){
        products = await ApiService.getMyProducts();
      }
    }

    setState(()=> loading = false);
  }

  deleteStore() async {
    final ok = await ApiService.deleteStore();

    if(ok["success"] == true){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Toko berhasil dihapus!"))
      );

      setState(() {
        store = null;
        products = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Toko Saya")),

      floatingActionButton: store != null
        ? FloatingActionButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage()),
              ).then((value)=> load());
            },
            child: const Icon(Icons.add),
          )
        : null,

      body: loading
        ? const Center(child: CircularProgressIndicator())

        : store == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text("Anda belum punya toko"),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddStorePage()),
                      ).then((value)=> load());
                    },
                    child: const Text("Buat Toko"),
                  )
                ],
              ),
            )

          : RefreshIndicator(
              onRefresh: () async => load(),
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [

                  if(store!["gambar"] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        store!["gambar"],
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  const SizedBox(height: 16),

                  Text(store!["nama_toko"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                            MaterialPageRoute(builder: 
                              (_) => EditStorePage(store: store!)
                            ),
                          ).then((value)=> load());
                        },
                        child: const Text("Edit Toko"),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: deleteStore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Hapus"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Produk Saya",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

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
            )
    );
  }
}
