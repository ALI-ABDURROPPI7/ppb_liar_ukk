import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_product_page.dart';
import 'store_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int index = 0;

  final screens = [
    const HomePage(),
    const AddProductPage(),
    const StorePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: screens[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        onTap: (i){
          setState(() {
            index = i;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Tambah",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: "Toko",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
