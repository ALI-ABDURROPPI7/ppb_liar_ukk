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
  final categoryIdC = TextEditingController();

  File? pickedImage;

  bool hasStore = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    checkStore();
  }

  pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(img != null){
      if(!mounted) return;
      setState(()=> pickedImage = File(img.path));
    }
  }

  checkStore() async {
    final res = await ApiService.getMyStore();
    if(res["success"] == true && res["data"] != null){
      if(!mounted) return;
      setState(()=> hasStore = true);
    }
  }

  saveProduct() async {

    if(categoryIdC.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Isi id kategori dulu"))
      );
      return;
    }

    if(mounted){
      setState(()=> loading = true);
    }

    final res = await ApiService.saveProduct(
      nameC.text,
      priceC.text,
      descC.text,
      stockC.text,
      categoryIdC.text,
      pickedImage?.path,
    );

    if(mounted){
      setState(()=> loading = false);
    }

    if(res["success"] == true){

      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil ditambahkan!"))
      );

      Navigator.pop(context, true); // <<<<<< ini penting!

    }else{
      if(!mounted) return;

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
                      height: 150,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: pickedImage == null
                          ? const Text("Pilih Gambar Produk")
                          : Image.file(pickedImage!, fit: BoxFit.cover),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: categoryIdC,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "ID Kategori",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      labelText: "Nama produk",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: priceC,
                    decoration: const InputDecoration(
                      labelText: "Harga",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: stockC,
                    decoration: const InputDecoration(
                      labelText: "Stok",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: descC,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi",
                      border: OutlineInputBorder(),
                    ),
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
