import 'package:flutter/material.dart';

class ActividadDetallePage extends StatefulWidget {
  final String materia;
  final String titulo;
  final String descripcion;
  final String fechaLimite;
  final Color color;

  const ActividadDetallePage({
    super.key,
    required this.materia,
    required this.titulo,
    required this.descripcion,
    required this.fechaLimite,
    required this.color,
  });

  @override
  State<ActividadDetallePage> createState() => _ActividadDetallePageState();
}

class _ActividadDetallePageState extends State<ActividadDetallePage>
    with SingleTickerProviderStateMixin {
  bool entregado = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  void _marcarComoEntregado() {
    setState(() {
      entregado = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: widget.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.materia,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              widget.descripcion,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Fecha límite: ${widget.fechaLimite}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
            const Spacer(),
            if (!entregado)
              Center(
                child: ElevatedButton(
                  onPressed: _marcarComoEntregado,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text(
                    "Marcar como Entregada",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            if (entregado)
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Center(
                  child: Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 80),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

