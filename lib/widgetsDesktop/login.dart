import 'package:flutter/material.dart';
import 'package:proyectoeducativo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyectoeducativo/widgetsDesktop/registro.dart';
import 'package:proyectoeducativo/widgetsDesktop/login.dart';
import 'package:proyectoeducativo/views/desktop/home_desktop.dart'; 



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  

  void _iniciarSesion() {
    if (_correoCtrl.text == _correoValido &&
        _contrasenaCtrl.text == _contrasenaValida) {
      _guardarPreferencias();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
      );
    } else {
      setState(() {
        _error = 'Correo o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 60, color: Colors.indigo),
                  const SizedBox(height: 16),
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _correoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contrasenaCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _recordarme,
                        onChanged: (value) {
                          setState(() {
                            _recordarme = value ?? false;
                          });
                        },
                      ),
                      const Text('Recordarme'),
                    ],
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _iniciarSesion,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo),
                      child: const Text('Ingresar'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegistroPage()),
                      );
                    },
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
