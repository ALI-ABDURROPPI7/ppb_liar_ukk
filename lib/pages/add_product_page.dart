import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'add_store_page.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final stockC = TextEditingController();
  final descC = TextEditingController();

  List categories = [];
  String? selectedCategory;

  File? pickedImage;

  bool hasStore = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    checkStore();
    loadCategories();
  }

  loadCategories() async {
    final data = await ApiService.getCategories();
    setState(() => categories = data);
  }

  pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(img != null){
      setState(()=> pickedImage = File(img.path));
    }
  }

  checkStore() async {
    final res = await ApiService.getMyStore();
    if(res["success"] == true && res["data"] != null){
      setState(()=> hasStore = true);
    }
  }

  saveProduct() async {

    if(selectedCategory == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori dulu"))
      );
      return;
    }

    setState(()=> loading = true);

    final res = await ApiService.saveProduct(
      nameC.text,
      priceC.text,
      descC.text,
      stockC.text,
      selectedCategory!,
      pickedImage?.path,
    );

    setState(()=> loading = false);

    if(res["success"] == true){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan!"))
      );
      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${res["message"]}"))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),

      body: hasStore == false
      ? Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddStorePage()),
            );
          },
          child: const Text("Anda belum punya toko, Buat toko"),
        ),
      )

      : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            InkWell(
              onTap: pickImage,
              child: Container(
                height: 140,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colors.grey.shade300,
                child: pickedImage == null
                  ? const Text("Pilih Gambar Produk")
                  : Image.file(pickedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            categories.isEmpty
            ? const Text("Memuat kategori...")
            : DropdownButtonFormField(
                value: selectedCategory,
                hint: const Text("Pilih kategori"), 
                decoration: const InputDecoration(labelText: "Kategori"),
                items: categories.map((e){
                  return DropdownMenuItem(
                    value: "${e['id']}",
                    child: Text(e['nama_kategori']),
                  );
                }).toList(),
                onChanged: (v){
                  setState(()=> selectedCategory = v);
                },
              ),

            const SizedBox(height: 20),

            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama produk"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: priceC,
              decoration: const InputDecoration(labelText: "Harga"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: stockC,
              decoration: const InputDecoration(labelText: "Stok"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descC,
              decoration: const InputDecoration(labelText: "Deskripsi"),
              maxLines: 3,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: loading ? null : saveProduct,
                child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Simpan"),
              ),
            )

          ],
        ),
      ),

    );
  }
}
