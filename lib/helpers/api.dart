import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/login.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/model/registrasi.dart';

class ApiService {
  static Future<Registrasi> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiUrl.registrasi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
      }),
    );

    final jsonObj = jsonDecode(response.body);
    return Registrasi.fromJson(jsonObj);
  }

  static Future<Login> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiUrl.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final jsonObj = jsonDecode(response.body);
    return Login.fromJson(jsonObj);
  }

  static Future<List<Produk>> getProduk() async {
    final response = await http.get(
      Uri.parse(ApiUrl.listProduk),
      headers: {'Content-Type': 'application/json'},
    );

    final jsonObj = jsonDecode(response.body);
    if (jsonObj['status'] == true && jsonObj['data'] is List) {
      List data = jsonObj['data'];
      return data.map((item) => Produk.fromJson(item)).toList();
    }
    return [];
  }

  static Future<bool> addProduk(Produk produk) async {
    final response = await http.post(
      Uri.parse(ApiUrl.createProduk),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'kode_produk': produk.kodeProduk,
        'nama_produk': produk.namaProduk,
        'harga': produk.hargaProduk,
      }),
    );

    final jsonObj = jsonDecode(response.body);
    return jsonObj['status'] == true;
  }

  static Future<bool> updateProduk(Produk produk) async {
    final response = await http.put(
      Uri.parse(ApiUrl.updateProduk(produk.id!)),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'kode_produk': produk.kodeProduk,
        'nama_produk': produk.namaProduk,
        'harga': produk.hargaProduk,
      }),
    );

    final jsonObj = jsonDecode(response.body);
    return jsonObj['status'] == true;
  }

  static Future<bool> deleteProduk(int id) async {
    final response = await http.delete(
      Uri.parse(ApiUrl.deleteProduk(id)),
      headers: {'Content-Type': 'application/json'},
    );

    final jsonObj = jsonDecode(response.body);
    return jsonObj['status'] == true;
  }
}

