import 'package:flutter/material.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Produk? produk;

  ProdukDetail({super.key, this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: _isDeleting
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Kode : ${widget.produk?.kodeProduk ?? ''}",
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nama : ${widget.produk?.namaProduk ?? ''}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Harga : Rp. ${widget.produk?.hargaProduk?.toString() ?? ''}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 24),
                  _tombolHapusEdit(),
                ],
              ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(
                  produk: widget.produk!,
                ),
              ),
            );
            if (result == true && mounted) {
              // Jika baru diupdate, kita refresh detail atau kembali ke halaman list
              Navigator.pop(context, true);
            }
          },
        ),
        const SizedBox(width: 16),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            Navigator.pop(context); // tutup dialog
            _prosesHapus();
          },
        ),
        // tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }

  void _prosesHapus() {
    setState(() {
      _isDeleting = true;
    });

    ApiService.deleteProduk(widget.produk!.id!).then((success) {
      if (!mounted) return;
      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _isDeleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus produk")),
        );
      }
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Koneksi Error: $error")),
      );
    });
  }
}
