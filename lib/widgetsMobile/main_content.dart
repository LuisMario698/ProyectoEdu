import 'package:flutter/material.dart';
import 'package:proyectoeducativo/views/mobile/horario_page.dart';
import 'package:proyectoeducativo/views/mobile/grupotrabajo_page.dart'; // Corrección del import
import 'package:proyectoeducativo/widgetsDesktop/grupos_trabajo.dart';
import 'horario.dart';
import 'calendario.dart';
import 'grupos_trabajo.dart';
import 'materias.dart';
import 'actividades.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenido a tu Plataforma Educativa',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aquí encontrarás toda la información sobre tus materias, actividades, horarios y más.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  'Materias',
                  Icons.auto_stories_sharp,
                  Colors.blue.shade100,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MateriasWidget(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  'Actividades',
                  Icons.assignment,
                  Colors.red.shade100,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ActividadesWidget(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  'Horario',
                  Icons.calendar_today,
                  Colors.green.shade100,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HorarioPage(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  'Calendario',
                  Icons.calendar_month,
                  Colors.purple.shade100,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CalendarioWidget(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  'Grupos de Trabajo',
                  Icons.group,
                  Colors.orange.shade100,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GrupoTrabajoPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, {required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.black54),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
