import 'package:flutter/material.dart';
import 'package:proyectoeducativo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyectoeducativo/widgetsDesktop/registro.dart';
import 'package:proyectoeducativo/widgetsDesktop/login.dart';
import 'package:proyectoeducativo/views/desktop/home_desktop.dart'; 



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  bool _recordarme = false;
  String? _error;

  final String _correoValido = 'admin.correo.com';
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
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email),
                      errorText: _error != null && _correoCtrl.text.isEmpty ? 'Por favor ingrese su correo' : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        _error = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contrasenaCtrl,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                      errorText: _error != null && _contrasenaCtrl.text.isEmpty ? 'Por favor ingrese su contraseña' : null,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _error = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _recordarme,
                        onChanged: (value) {
                          setState(() {
                            _recordarme = value!;
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TeamsScreen()),
                        );
                      },
                      child: const Text('Iniciar Sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
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
