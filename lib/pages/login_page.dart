import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import 'main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final usernameC = TextEditingController();
  final passwordC = TextEditingController();

  bool loading = false;

  login() async {

    if(usernameC.text.isEmpty || passwordC.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username & password tidak boleh kosong"))
      );
      return;
    }

    setState(()=> loading = true);

    final res = await ApiService.login(
      usernameC.text,
      passwordC.text,
    );

    setState(()=> loading = false);

    if(res["success"] == true){

      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString("token", res["token"]);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login berhasil!"))
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${res["message"]}"))
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 60),

              const Text("Login",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text("Silahkan masuk untuk melanjutkan",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 40),


              TextField(
                controller: usernameC,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordC,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),


              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login", style: TextStyle(color: Colors.white)),
                ),
              ),


              const Spacer(),

              Center(
                child: TextButton(
                  onPressed: (){

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_)=> const RegisterPage()),
                    );

                  },
                  child: const Text("Belum punya akun? Register"),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
