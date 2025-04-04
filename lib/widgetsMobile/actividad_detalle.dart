import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsMobile/actividad_modelo.dart';

class ActividadDetallePage extends StatefulWidget {
  final Actividad actividad;

  const ActividadDetallePage({
    super.key,
    required this.actividad,
  });

  @override
  State<ActividadDetallePage> createState() => _ActividadDetallePageState();
}

class _ActividadDetallePageState extends State<ActividadDetallePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _animacionCompletada = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    
    // Si la actividad ya está entregada, mostramos el ícono de completado
    if (widget.actividad.estado == 'entregada') {
      _animacionCompletada = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _marcarComoEntregado() {
    setState(() {
      widget.actividad.marcarComoEntregada();
      _animacionCompletada = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.actividad.titulo),
        backgroundColor: widget.actividad.color,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta principal con información de la actividad
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: widget.actividad.color.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.actividad.materia,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.actividad.descripcion,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Fecha límite: ${widget.actividad.fechaLimiteStr}',
                              style: const TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Estado actual
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        widget.actividad.iconoEstado,
                        color: widget.actividad.colorEstado,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Estado: ${widget.actividad.estado == 'entregada' ? 'Entregada' : (widget.actividad.estado == 'no_entregada' ? 'No Entregada' : 'Pendiente')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.actividad.colorEstado,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Botón para marcar como entregada o animación de completado
              Center(
                child: _animacionCompletada
                    ? widget.actividad.estado == 'entregada'
                        ? ScaleTransition(
                            scale: _controller.value == 0 ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
                            child: const Column(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                                SizedBox(height: 8),
                                Text(
                                  "¡Actividad Entregada!",
                                  style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()
                    : ElevatedButton(
                        onPressed: _marcarComoEntregado,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 8),
                            Text("Marcar como Entregada", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}