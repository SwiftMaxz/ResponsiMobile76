import 'package:flutter/material.dart';
import '/bloc/registrasi_bloc.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFF5F6D), Color(0xffFFC371)], // Warm gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 30),
                    _namaTextField(),
                    const SizedBox(height: 20),
                    _emailTextField(),
                    const SizedBox(height: 20),
                    _passwordTextField(),
                    const SizedBox(height: 20),
                    _passwordKonfirmasiTextField(),
                    const SizedBox(height: 30),
                    _buttonRegistrasi(),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Icon(Icons.person_add, size: 100, color: Colors.white.withOpacity(0.8)),
        const SizedBox(height: 16),
        const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nama",
        fillColor: Colors.white.withOpacity(0.9),
        filled: true,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.person, color: Colors.black54),
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus lebih dari 3 karakter";
        }
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        fillColor: Colors.white.withOpacity(0.9),
        filled: true,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.email, color: Colors.black54),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Silahkan masukkan email anda';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        fillColor: Colors.white.withOpacity(0.9),
        filled: true,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.lock, color: Colors.black54),
      ),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus lebih dari 6 karakter";
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Konfirmasi Password",
        fillColor: Colors.white.withOpacity(0.9),
        filled: true,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
      ),
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Password tidak cocok";
        }
        return null;
      },
    );
  }

  Widget _buttonRegistrasi() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepOrangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Daftar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
      onPressed: _isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });

                try {
                  final result = await RegistrasiBloc.registrasi(
                    nama: _namaTextboxController.text,
                    email: _emailTextboxController.text,
                    password: _passwordTextboxController.text,
                  );

                  if (result.status == true) {
                    Navigator.pop(context); // Registration successful
                  } else {
                    setState(() {
                      _errorMessage = result.data;
                    });
                  }
                } catch (e) {
                  setState(() {
                    _errorMessage = "Terjadi kesalahan. Silahkan coba lagi.";
                  });
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
    );
  }
}
