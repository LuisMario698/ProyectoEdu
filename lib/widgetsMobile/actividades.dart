import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsMobile/actividad_modelo.dart';
import 'package:proyectoeducativo/widgetsMobile/actividad_detalle.dart';

class ActividadesWidget extends StatelessWidget {
  final String? materiaSeleccionada;

  const ActividadesWidget({
    super.key,
    this.materiaSeleccionada
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actividades'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'No Entregadas'),
              Tab(text: 'Entregadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(listaActividades.where((a) => a.estado == 'pendiente').toList(), context),
            _buildList(listaActividades.where((a) => a.estado == 'no_entregada').toList(), context),
            _buildList(listaActividades.where((a) => a.estado == 'entregada').toList(), context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Agregar nueva actividad')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildList(List<Actividad> items, BuildContext context) {
    // Filtramos por materia seleccionada si existe
    final actividadesFiltradas = materiaSeleccionada != null
        ? items.where((a) => a.materia == materiaSeleccionada).toList()
        : items;
        
    return ListView(
      children: _buildActividades(actividadesFiltradas, context),
    );
  }

  List<Widget> _buildActividades(List<Actividad> actividades, BuildContext context) {
    return actividades
        .map((actividad) => Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: actividad.color,
          child: ExpansionTile(
            title: Text(
              actividad.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(actividad.materia),
            leading: Icon(
              actividad.iconoEstado,
              color: actividad.colorEstado,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Descripción: ${actividad.descripcion}'),
                    const SizedBox(height: 8),
                    Text('Fecha límite: ${actividad.fechaLimiteStr}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (actividad.estado != 'entregada')
                          ElevatedButton(
                            onPressed: () {
                              // Lógica para marcar como entregada
                              actividad.marcarComoEntregada();
                              // Forzar reconstrucción
                              (context as Element).markNeedsBuild();
                            },
                            child: const Text('Marcar como entregada'),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActividadDetallePage(
                                  actividad: actividad,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Ver detalles'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ))
        .toList();
  }
}

final List<Actividad> listaActividades = [
  Actividad(
    titulo: 'Práctica de patrones de diseño',
    descripcion: 'Implementar 3 patrones de diseño',
    materia: 'Tópicos Avanzados de Programación',
    fecha: DateTime.now().add(const Duration(days: 3)),
    fechaLimiteStr: '15 Julio 2024',
    estado: 'pendiente',
    color: Colors.blue[100]!,
  ),
  Actividad(
    titulo: 'Proyecto circuito integrado',
    descripcion: 'Diseñar circuito con 5 compuertas lógicas',
    materia: 'Principios Eléctricos y Aplicaciones Digitales',
    fecha: DateTime.now().add(const Duration(days: -2)),
    fechaLimiteStr: '5 Julio 2024',
    estado: 'no_entregada',
    color: Colors.red[100]!,
  ),
  Actividad(
    titulo: 'Examen parcial ecuaciones',
    descripcion: 'Resolver 10 ecuaciones diferenciales',
    materia: 'Ecuaciones Diferenciales',
    fecha: DateTime.now().add(const Duration(days: 7)),
    fechaLimiteStr: '20 Julio 2024',
    estado: 'pendiente',
    color: Colors.green[100]!,
  ),
  Actividad(
    titulo: 'Presentación perfect tenses',
    descripcion: 'Preparar exposición sobre tiempos verbales',
    materia: 'Inglés 4',
    fecha: DateTime.now().add(const Duration(days: 5)),
    fechaLimiteStr: '18 Julio 2024',
    estado: 'entregada',
    color: Colors.purple[100]!,
  ),
];
