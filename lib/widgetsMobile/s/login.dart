import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageMobile extends StatefulWidget {
  const LoginPageMobile({super.key});

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  bool _recordarme = false;
  String? _error;

  final String _correoValido = 'admin@correo.com';
  final String _contrasenaValida = '123456';

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _correoCtrl.text = prefs.getString('correoRecordado') ?? '';
      _recordarme = prefs.getBool('recordarme') ?? false;
    });
  }

  Future<void> _guardarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    if (_recordarme) {
      await prefs.setString('correoRecordado', _correoCtrl.text);
      await prefs.setBool('recordarme', true);
    } else {
      await prefs.remove('correoRecordado');
      await prefs.setBool('recordarme', false);
    }
  }

  void _login() {
    if (_correoCtrl.text == _correoValido && _contrasenaCtrl.text == _contrasenaValida) {
      _guardarPreferencias();
      Navigator.pushReplacementNamed(context, '/homeMobile');
    } else {
      setState(() {
        _error = 'Correo o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Móvil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _correoCtrl,
              decoration: InputDecoration(labelText: 'Correo', errorText: _error),
            ),
            TextField(
              controller: _contrasenaCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: _recordarme,
                  onChanged: (bool? value) {
                    setState(() {
                      _recordarme = value ?? false;
                    });
                  },
                ),
                const Text('Recordarme')
              ],
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}