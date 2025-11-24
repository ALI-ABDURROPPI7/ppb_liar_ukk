import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://learncode.biz.id/api";


  // ================= LOGIN =====================
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final res = await http.post(url, body: {
      "username": username,
      "password": password,
    });

    return json.decode(res.body);
  }


  // ================= GET PRODUCTS =====================
  static Future<List> getProducts() async {
    final url = Uri.parse("$baseUrl/products");
    final res = await http.get(url);
    return json.decode(res.body)["data"];
  }


  // ================= GET MY PRODUCTS =====================
  static Future<List> getMyProducts() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/products/my");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"}
    );

    return json.decode(res.body)["data"];
  }


  // ================= GET CATEGORIES =====================
  static Future<List> getCategories() async {
    final url = Uri.parse("$baseUrl/categories");
    final res = await http.get(url);
    return json.decode(res.body)["data"];
  }


  // ================= GET MY STORE =====================
  static Future<Map<String, dynamic>> getMyStore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/stores");

    final res = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    return json.decode(res.body);
  }


  // ================= CREATE STORE =====================
  static Future<Map<String, dynamic>> createStore(
      String name,
      String desc,
      String phone,
      String address,
      String? imagePath,
  ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/stores/save");

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = "Bearer $token";

    request.fields["nama_toko"] = name;
    request.fields["deskripsi"] = desc;
    request.fields["kontak"] = phone;
    request.fields["alamat"] = address;

    if(imagePath != null && imagePath != ""){
      request.files.add(await http.MultipartFile.fromPath("gambar", imagePath));
    }

    var res = await request.send();
    var body = await res.stream.bytesToString();

    return json.decode(body);
  }



  // ================= UPDATE STORE =====================
  static Future<Map<String, dynamic>> updateStore(
      String name,
      String desc,
      String phone,
      String address,
      String? imagePath,
  ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/stores/update");

    var req = http.MultipartRequest("POST", url);

    req.headers["Authorization"] = "Bearer $token";

    req.fields["nama_toko"] = name;
    req.fields["deskripsi"] = desc;
    req.fields["kontak"] = phone;
    req.fields["alamat"] = address;

    if(imagePath != null){
      req.files.add(await http.MultipartFile.fromPath("gambar", imagePath));
    }

    var res = await req.send();
    var body = await res.stream.bytesToString();

    return json.decode(body);
  }



  // ================= DELETE STORE =====================
  static Future<Map<String, dynamic>> deleteStore() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/stores/delete");

    final res = await http.post(url, headers:{
      "Authorization": "Bearer $token"
    });

    return json.decode(res.body);
  }



  // ================= SAVE PRODUCT =====================
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

    final url = Uri.parse("$baseUrl/products/save");

    var req = http.MultipartRequest("POST", url);

    req.headers["Authorization"] = "Bearer $token";

    req.fields["nama_produk"]   = name;
    req.fields["harga"]         = price;
    req.fields["stok"]          = stock;
    req.fields["id_kategori"]   = categoryId;
    req.fields["deskripsi"]     = desc;

    if(imagePath != null && imagePath != ""){
      req.files.add(await http.MultipartFile.fromPath("gambar", imagePath));
    }

    var res = await req.send();
    var body = await res.stream.bytesToString();

    return json.decode(body);
  }



  // ================= UPDATE PRODUCT =====================
  static Future<Map<String, dynamic>> updateProduct(
      String id,
      String name,
      String price,
      String desc,
      String stock,
      String categoryId,
      String? image,
  ) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/products/update/$id");

    var req = http.MultipartRequest("POST", url);

    req.headers["Authorization"] = "Bearer $token";

    req.fields["nama_produk"] = name;
    req.fields["harga"] = price;
    req.fields["stok"] = stock;
    req.fields["id_kategori"] = categoryId;
    req.fields["deskripsi"] = desc;

    if(image != null){
      req.files.add(await http.MultipartFile.fromPath("gambar", image));
    }

    var res = await req.send();
    var body = await res.stream.bytesToString();

    return json.decode(body);
  }



  // ================= DELETE PRODUCT =====================
  static Future<Map<String, dynamic>> deleteProduct(String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/products/delete/$id");

    final res = await http.post(
      url,
      headers: {"Authorization": "Bearer $token"}
    );

    return json.decode(res.body);
  }



  // ================= GET PROFILE =====================
  static Future<Map<String, dynamic>> getProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString("token");

    final url = Uri.parse("$baseUrl/profile");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"}
    );

    return json.decode(res.body);
  }

}
