import 'package:flutter/material.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  void dispose() {
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                const SizedBox(height: 24),
                _buttonLogin(),
                const SizedBox(height: 30),
                _menuRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Login
  Widget _buttonLogin() {
    return _isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("Login"),
              onPressed: () {
                var validate = _formKey.currentState!.validate();
                if (validate) {
                  _prosesLogin();
                }
              },
            ),
          );
  }

  void _prosesLogin() {
    setState(() {
      _isLoading = true;
    });

    ApiService.login(
      email: _emailTextboxController.text.trim(),
      password: _passwordTextboxController.text,
    ).then((res) async {
      setState(() {
        _isLoading = false;
      });

      if (res.status == true && res.token != null) {
        await UserInfo.setToken(res.token!);
        if (res.userID != null) {
          await UserInfo.setUserID(res.userID!);
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProdukPage()),
        );
      } else {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Login Gagal"),
            content: Text(res.message ?? "Email atau Password salah!"),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Koneksi Error"),
          content: Text("Gagal terhubung ke server API:\n$error"),
          actions: [
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    });
  }

  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
