import 'package:flutter/material.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/model/produk.dart';

// ignore: must_be_immutable
class ProdukForm extends StatefulWidget {
  Produk? produk;

  ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  @override
  void dispose() {
    _kodeProdukTextboxController.dispose();
    _namaProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    super.dispose();
  }

  void isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "UBAH";
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? '';
        _namaProdukTextboxController.text = widget.produk!.namaProduk ?? '';
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk?.toString() ?? '';
      });
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                const SizedBox(height: 24),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Kode Produk
  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Nama Produk
  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Harga Produk
  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Harga harus diisi";
        }
        if (int.tryParse(value.trim()) == null) {
          return "Harga harus berupa angka";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return _isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              child: Text(tombolSubmit),
              onPressed: () {
                var validate = _formKey.currentState!.validate();
                if (validate) {
                  _simpanData();
                }
              },
            ),
          );
  }

  void _simpanData() {
    setState(() {
      _isLoading = true;
    });

    Produk createProduk = Produk(
      id: widget.produk?.id,
      kodeProduk: _kodeProdukTextboxController.text.trim(),
      namaProduk: _namaProdukTextboxController.text.trim(),
      hargaProduk: int.parse(_hargaProdukTextboxController.text.trim()),
    );

    if (widget.produk != null) {
      // Mode Ubah
      ApiService.updateProduk(createProduk).then((success) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        if (success) {
          Navigator.pop(context, true);
        } else {
          _showErrorDialog("Gagal mengubah data produk");
        }
      }).catchError((error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog("Koneksi Error: $error");
      });
    } else {
      // Mode Tambah
      ApiService.addProduk(createProduk).then((success) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        if (success) {
          Navigator.pop(context, true);
        } else {
          _showErrorDialog("Gagal menambah data produk");
        }
      }).catchError((error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog("Koneksi Error: $error");
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Peringatan"),
        content: Text(message),
        actions: [
          ElevatedButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
