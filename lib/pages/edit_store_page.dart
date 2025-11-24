import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class EditStorePage extends StatefulWidget {
  final Map store;
  const EditStorePage({super.key, required this.store});

  @override
  State<EditStorePage> createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {

  File? pickedImage;
  bool loading = false;

  late TextEditingController nameC;
  late TextEditingController descC;
  late TextEditingController phoneC;
  late TextEditingController addressC;

  @override
  void initState() {
    nameC = TextEditingController(text: widget.store['nama_toko']);
    descC = TextEditingController(text: widget.store['deskripsi']);
    phoneC = TextEditingController(text: widget.store['kontak']);
    addressC = TextEditingController(text: widget.store['alamat']);
    super.initState();
  }

  pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(img != null){
      setState(()=> pickedImage = File(img.path));
    }
  }

  save() async {

    setState(()=> loading = true);

    final res = await ApiService.updateStore(
      nameC.text,
      descC.text,
      phoneC.text,
      addressC.text,
      pickedImage?.path,
    );

    setState(()=> loading = false);

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Toko")),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            InkWell(
              onTap: pickImage,
              child: Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: pickedImage == null
                  ? const Text("Ubah Gambar")
                  : Image.file(pickedImage!, fit: BoxFit.cover),
              ),
            ),

            SizedBox(height: 20),

            TextField(controller: nameC, decoration: InputDecoration(labelText: "Nama toko")),
            TextField(controller: descC, decoration: InputDecoration(labelText: "Deskripsi")),
            TextField(controller: phoneC, decoration: InputDecoration(labelText: "WA")),
            TextField(controller: addressC, decoration: InputDecoration(labelText: "Alamat")),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
