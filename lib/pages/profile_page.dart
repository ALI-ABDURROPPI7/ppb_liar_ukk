import 'package:flutter/material.dart';
import '../services/api_service.dart';
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
    return user == null
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [

              const SizedBox(height: 30),

              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade600,
                child: Text(
                  user!["name"].toString().substring(0,1).toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                user!["name"],
                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),

              Text(
                "@${user!["username"]}",
                style: const TextStyle(fontSize: 16, color: Colors.black45),
              ),

              const SizedBox(height: 30),

              if(user!["email"] != null)
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(user!["email"]),
                ),

              if(user!["phone"] != null)
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(user!["phone"]),
                ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                  ),
                  child: const Text("Logout"),
                ),
              )
            ],
          ),
        ),
      );
  }
}
