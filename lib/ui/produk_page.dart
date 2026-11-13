import 'package:flutter/material.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> _futureProduk;

  @override
  void initState() {
    super.initState();
    _refreshProduk();
  }

  void _refreshProduk() {
    setState(() {
      _futureProduk = ApiService.getProduk();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                );
                _refreshProduk();
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await UserInfo.logout();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshProduk(),
        child: FutureBuilder<List<Produk>>(
          future: _futureProduk,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 8),
                      Text(
                        'Gagal memuat data produk:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshProduk,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return const Center(
                child: Text('Belum ada data produk.\nTekan tombol + untuk menambah.',
                    textAlign: TextAlign.center),
              );
            }

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ItemProduk(
                  produk: list[index],
                  onChanged: _refreshProduk,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback? onChanged;

  const ItemProduk({super.key, required this.produk, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(
              produk: produk,
            ),
          ),
        );
        onChanged?.call();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          title: Text(produk.namaProduk ?? ''),
          subtitle: Text('Rp. ${produk.hargaProduk?.toString() ?? '0'}'),
          trailing: Text(
            produk.kodeProduk ?? '',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
