import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class BienvenidaWidget extends StatefulWidget {
  final VoidCallback onEmpezar;
  const BienvenidaWidget({super.key, required this.onEmpezar});

  @override
  State<BienvenidaWidget> createState() => _BienvenidaWidgetState();
}

class _BienvenidaWidgetState extends State<BienvenidaWidget>
    with TickerProviderStateMixin {
  bool _animando = false;
  final List<_Burbuja> _burbujas = [];

  void _iniciarAnimacionYNotificar() {
    setState(() => _animando = true);
    for (int i = 0; i < 25; i++) {
      _burbujas.add(_Burbuja(
        key: UniqueKey(),
        delay: Duration(milliseconds: 80 * i),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ));
    }
    Future.delayed(const Duration(milliseconds: 3000), () {
      widget.onEmpezar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          left: -50,
          child: Transform.rotate(
            angle: -pi / 6,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          right: -40,
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        if (_animando) ..._burbujas,
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bienvenido a tu agenda escolar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _animando ? null : _iniciarAnimacionYNotificar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Empezar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _Burbuja extends StatefulWidget {
  final Duration delay;
  final Color color;

  const _Burbuja({super.key, required this.delay, required this.color});

  @override
  State<_Burbuja> createState() => _BurbujaState();
}

class _BurbujaState extends State<_Burbuja> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animacion;
  late final double size;

  @override
  void initState() {
    super.initState();
    size = 30 + Random().nextDouble() * 50;
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animacion = Tween<Offset>(
      begin: Offset(Random().nextDouble() * 2 - 1, 1.2),
      end: Offset(Random().nextDouble() * 2 - 1, -2.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animacion,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
