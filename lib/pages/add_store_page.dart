import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {

  final nameC = TextEditingController();
  final descC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();

  File? pickedImage;
  bool loading = false;

  pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(img != null){
      setState(()=> pickedImage = File(img.path));
    }
  }

  saveStore() async {

    // VALIDASI WAJIB
    if(nameC.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama toko wajib diisi"))
      );
      return;
    }

    if(phoneC.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kontak WA wajib diisi"))
      );
      return;
    }

    setState(()=> loading = true);

    final res = await ApiService.createStore(
      nameC.text,
      descC.text,
      phoneC.text,
      addressC.text,
      pickedImage?.path ?? "",   // <= biar aman walaupun null
    );

    setState(()=> loading = false);

    if(res["success"] == true){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Toko berhasil ditambahkan!"))
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
      appBar: AppBar(title: const Text("Buat Toko")),

      body: SingleChildScrollView(
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
                    ? const Text("Pilih Gambar (optional)")
                    : Image.file(pickedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama Toko"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descC,
              decoration: const InputDecoration(labelText: "Deskripsi Toko"),
              maxLines: 2,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneC,
              decoration: const InputDecoration(labelText: "Kontak WhatsApp"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressC,
              decoration: const InputDecoration(labelText: "Alamat Toko"),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: loading ? null : saveStore,
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
