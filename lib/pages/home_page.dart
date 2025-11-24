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
      products = allProducts.where((p){
        return p["id_kategori"].toString() == id;
      }).toList();
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
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage())
              );
              loadProducts();
            },
            child: const Icon(Icons.add),
          )
        : null,


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i){
          setState(()=> currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Toko"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),

    );
  }


  Widget homeView(){

    if(loading){
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [

        /// CATEGORY
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [

              GestureDetector(
                onTap: resetFilter,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: 80,
                  decoration: BoxDecoration(
                    color: selectedCategory == null
                      ? Colors.blue.shade100
                      : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.all_inclusive),
                      SizedBox(height: 4),
                      Text("Semua", style: TextStyle(fontSize: 11))
                    ],
                  ),
                ),
              ),

              ...categories.map((c){

                return GestureDetector(
                  onTap: ()=> filterByCategory("${c['id']}"),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: 80,
                    decoration: BoxDecoration(
                      color: selectedCategory == "${c['id']}"
                        ? Colors.blue.shade300
                        : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(height: 4),
                        Text(
                          c['nama_kategori'],
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );

              }).toList(),

            ],
          ),
        ),


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

              final img = p['gambar'] != null && p['gambar'] != ""
                  ? p['gambar']
                  : "https://via.placeholder.com/300?text=No+Image";


              return InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DetailPage(product: p))
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black12)
                  ),
                  child: Column(
                    children: [

                      Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              img,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
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

}
