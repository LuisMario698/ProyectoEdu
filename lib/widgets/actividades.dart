import 'package:flutter/material.dart';

class ActividadesWidget extends StatelessWidget {
  const ActividadesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text('Actividades'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'No Entregadas'),
              Tab(text: 'Entregadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList([
              'Tarea 1',
              'Tarea 2',
              'Tarea 3',
            ]), // Lista de pendientes
            _buildList(['Tarea 4', 'Tarea 5']), // Lista de no entregadas
            _buildList([
              'Tarea 6',
              'Tarea 7',
              'Tarea 8',
            ]), // Lista de entregadas
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(items[index]));
      },
    );
  }
}
