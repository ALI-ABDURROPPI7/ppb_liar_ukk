import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'add_product_page.dart';
import 'store_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;

  List products = [];
  List allProducts = [];
  List categories = [];

  bool loading = true;

  String? selectedCategory;

  final searchC = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadProducts();
    loadCategories();
  }

  loadProducts() async {
    final data = await ApiService.getProducts();
    setState(() {
      allProducts = data;
      products = data;
      loading = false;
    });
  }

  loadCategories() async {
    final data = await ApiService.getCategories();
    setState(() => categories = data);
  }

  filterByCategory(String id){
    setState(() {
      selectedCategory = id;
      products = allProducts.where((p) => p["id_kategori"].toString() == id).toList();
    });
  }

  resetFilter(){
    setState(() {
      selectedCategory = null;
      products = allProducts;
    });
  }

  @override
  Widget build(BuildContext context) {

    final pages = [
      homeView(),
      const StorePage(),
      const ProfilePage(),
    ];

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Marketplace Sekolah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: pages[currentIndex],

      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
        onPressed: () async {
          
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage())
          );

          if(res == true){
            loadProducts();
          }

        },
      )
          : null,

    );
  }


  Widget homeView(){

    if(loading){
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [

        const SizedBox(height: 8),

        // SEARCH
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: searchC,
            onChanged: (v){
              v = v.toLowerCase();
              setState(() {
                products = allProducts.where((p){
                  return p["nama_produk"].toString().toLowerCase().contains(v);
                }).toList();
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari produk...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// CATEGORY
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [

              GestureDetector(
                onTap: resetFilter,
                child: categoryCard(
                  active: selectedCategory == null,
                  title: "Semua",
                ),
              ),

              ...categories.map((c){
                return GestureDetector(
                  onTap: ()=> filterByCategory("${c['id']}"),
                  child: categoryCard(
                    active: selectedCategory == "${c['id']}",
                    title: c['nama_kategori'],
                  ),
                );
              }).toList(),
            ],
          ),
        ),


        const SizedBox(height: 6),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: .73
            ),
            itemCount: products.length,
            itemBuilder: (ctx, i){

              final p = products[i];
              final String img = (p['gambar'] ?? "").toString();

              return InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DetailPage(product: p))
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: const[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ]
                  ),
                  child: Column(
                    children: [

                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: img == ""
                              ? Container(
                            color: Colors.grey.shade300,
                            child: const Center(child: Text("No Image")),
                          )
                              : Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        p["nama_produk"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Rp ${p["harga"]}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )

      ],
    );

  }

  // CARD KATEGORI REUSABLE
  Widget categoryCard({required bool active, required String title}) {
    return Container(
      margin: const EdgeInsets.only(left:10),
      padding: const EdgeInsets.all(10),
      width: 90,
      decoration: BoxDecoration(
        color: active ? Colors.blue.shade400 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: active ? Colors.white : Colors.black,
            fontWeight: active ? FontWeight.bold : FontWeight.normal
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}
