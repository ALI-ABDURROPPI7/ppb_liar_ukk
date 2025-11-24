import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static const String baseUrl = "https://learncode.biz.id/api";

  // ===============================
  // AUTH
  // ===============================

  // LOGIN
  static Future<Map<String, dynamic>> login(
      String username,
      String password
      ) async {

    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {
        "username": username,
        "password": password,
      },
    );

    return json.decode(res.body);
  }


  // REGISTER (UPDATED)
  static Future<Map<String, dynamic>> register(
      String name,
      String username,
      String phone,
      String password
      ) async {

    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      body: {
        "name": name,
        "username": username,
        "phone": phone,
        "password": password,
        "password_confirmation": password,
      },
    );

    return json.decode(res.body);
  }



  // ===============================
  // PRODUCT
  // ===============================

  static Future<List> getProducts() async {
    final res = await http.get(Uri.parse("$baseUrl/products"));
    final body = json.decode(res.body);
    return body["data"] ?? [];
  }

  static Future<List> getMyProducts() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final res = await http.get(
      Uri.parse("$baseUrl/products/my"),
      headers: {"Authorization": "Bearer $token"},
    );

    return json.decode(res.body)["data"] ?? [];
  }

  static Future<Map<String, dynamic>> saveProduct(
      String name,
      String price,
      String desc,
      String stock,
      String categoryId,
      String? imagePath,
      ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    var req = http.MultipartRequest("POST", Uri.parse("$baseUrl/products/save"));
    req.headers["Authorization"] = "Bearer $token";

    req.fields["nama_produk"] = name;
    req.fields["harga"] = price;
    req.fields["stok"] = stock;
    req.fields["id_kategori"] = categoryId;
    req.fields["deskripsi"] = desc;

    if(imagePath != null && imagePath != "") {
      req.files.add(await http.MultipartFile.fromPath("gambar", imagePath));
    }

    final res = await req.send();
    return json.decode(await res.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> updateProduct(
      String id,
      String name,
      String price,
      String desc,
      String stock,
      String categoryId,
      String? imagePath,
      ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    var req = http.MultipartRequest("POST", Uri.parse("$baseUrl/products/update/$id"));
    req.headers["Authorization"] = "Bearer $token";

    req.fields["nama_produk"] = name;
    req.fields["harga"] = price;
    req.fields["stok"] = stock;
    req.fields["id_kategori"] = categoryId;
    req.fields["deskripsi"] = desc;

    if(imagePath != null && imagePath != "") {
      req.files.add(await http.MultipartFile.fromPath("gambar", imagePath));
    }

    final res = await req.send();
    return json.decode(await res.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> deleteProduct(String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final res = await http.post(
      Uri.parse("$baseUrl/products/delete/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    return json.decode(res.body);
  }



  // ===============================
  // CATEGORY
  // ===============================

  static Future<List> getCategories() async {
    final res = await http.get(Uri.parse("$baseUrl/categories"));
    return json.decode(res.body)["data"] ?? [];
  }



  // ===============================
  // STORE
  // ===============================

  static Future<Map<String, dynamic>> getMyStore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final res = await http.get(
      Uri.parse("$baseUrl/stores"),
      headers: {"Authorization": "Bearer $token"},
    );

    return json.decode(res.body);
  }

  static Future<Map<String, dynamic>> createStore(
      String name,
      String desc,
      String phone,
      String address,
      String? imagePath,
      ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    var req = http.MultipartRequest("POST", Uri.parse("$baseUrl/stores/save"));
    req.headers["Authorization"] = "Bearer $token";

    req.fields["nama_toko"] = name;
    req.fields["deskripsi"] = desc;
    req.fields["kontak"] = phone;
    req.fields["alamat"] = address;

    if(imagePath != null && imagePath != "") {
      req.files.add(await http.MultipartFile.fromPath("gambar", imagePath));
    }

    final res = await req.send();
    return json.decode(await res.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> updateStore(
      String name,
      String desc,
      String phone,
      String address,
      String? imagePath,
      ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    var req = http.MultipartRequest("POST", Uri.parse("$baseUrl/stores/update"));
    req.headers["Authorization"] = "Bearer $token";

    req.fields["nama_toko"] = name;
    req.fields["deskripsi"] = desc;
    req.fields["kontak"] = phone;
    req.fields["alamat"] = address;

    if(imagePath != null && imagePath != "") {
      req.files.add(await http.MultipartFile.fromPath("gambar", imagePath));
    }

    final res = await req.send();
    return json.decode(await res.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> deleteStore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final res = await http.post(
      Uri.parse("$baseUrl/stores/delete"),
      headers: {"Authorization": "Bearer $token"},
    );

    return json.decode(res.body);
  }



  // ===============================
  // PROFILE
  // ===============================

  static Future<Map<String, dynamic>> getProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final res = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {"Authorization": "Bearer $token"},
    );

    return json.decode(res.body);
  }

  static Future<Map<String, dynamic>> updateProfile(
      String name,
      String email,
      String phone
      ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final res = await http.post(
      Uri.parse("$baseUrl/profile/update"),
      headers: {"Authorization": "Bearer $token"},
      body: {
        "name": name,
        "email": email,
        "phone": phone,
      },
    );

    return json.decode(res.body);
  }

}
