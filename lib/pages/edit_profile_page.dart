import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController phoneC;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    nameC = TextEditingController(text: widget.user["name"] ?? "");
    emailC = TextEditingController(text: widget.user["email"] ?? "");
    phoneC = TextEditingController(text: widget.user["phone"] ?? "");
  }

  save() async {

    if(nameC.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama wajib diisi"))
      );
      return;
    }

    setState(()=> loading = true);

    final res = await ApiService.updateProfile(
      nameC.text,
      emailC.text,
      phoneC.text,
    );

    setState(()=> loading = false);

    if(res["success"] == true){
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diupdate"))
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"] ?? "Gagal update!"))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Edit Profil")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama"),
            ),

            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: phoneC,
              decoration: const InputDecoration(labelText: "No HP"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 47,
              child: ElevatedButton(
                onPressed: loading ? null : save,
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
