import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map? user;

  load() async {
    final res = await ApiService.getProfile();
    setState(()=> user = res['data']);
  }

  logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {

    if(user == null){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditProfilePage(user: user!)
                ),
              ).then((value){
                if(value == true){
                  load();
                }
              });
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                (user?["name"] ?? "-").toString().substring(0,1).toUpperCase(),
                style: const TextStyle(fontSize: 42,color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user?["name"] ?? "-",
              style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
            ),

            Text(
              "@${user?["username"] ?? "-"}",
              style: const TextStyle(color: Colors.black45),
            ),

            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user?["email"] ?? "-"),
            ),

            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(user?["phone"] ?? "-"),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Logout"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
