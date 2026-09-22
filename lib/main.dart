import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Panel de hábitos',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const PanelHabitos(),
    );
  }
}

class PanelHabitos extends StatefulWidget {
  const PanelHabitos({super.key});

  @override
  State<PanelHabitos> createState() => _PanelHabitosState();
}

class _PanelHabitosState extends State<PanelHabitos> {
  final List<String> _habitos = const [
    'Beber 2 L de agua',
    'Leer 20 minutos',
    'Caminar 30 minutos',
    'Estudiar Flutter',
    'Dormir 8 horas',
  ];

  late List<bool> _cumplidos;
  int _meta = 3;
  bool _enfoque = false;
  String _nota = '';
  final TextEditingController _notaCtrl = TextEditingController();

  int get _totalCumplidos => _cumplidos.where((cumplido) => cumplido).length;

  double get _progreso => _totalCumplidos / _habitos.length;

  bool get _metaAlcanzada => _totalCumplidos >= _meta;

  String get _mensaje {
    if (_progreso == 0) {
      return '¡Empecemos!';
    } else if (_progreso < 0.5) {
      return 'Buen inicio';
    } else if (_progreso < 1) {
      return '¡Vas muy bien!';
    }
    return '¡Día completado! 🎉';
  }

  @override
  void initState() {
    super.initState();
    _cumplidos = List<bool>.filled(_habitos.length, false);
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  void _alternarHabito(int indice, bool? valor) {
    setState(() {
      _cumplidos[indice] = valor ?? false;
    });
  }

  void _cambiarMeta(double valor) {
    setState(() {
      _meta = valor.round();
    });
  }

  void _alternarEnfoque(bool valor) {
    setState(() {
      _enfoque = valor;
    });
  }

  void _guardarNota() {
    setState(() {
      _nota = _notaCtrl.text.trim();
      _notaCtrl.clear();
    });
  }

  void _reiniciarDia() {
    setState(() {
      _cumplidos = List<bool>.filled(_habitos.length, false);
      _meta = 3;
      _enfoque = false;
      _nota = '';
      _notaCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int porcentaje = (_progreso * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cumplidos: $_totalCumplidos / ${_habitos.length}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            LinearProgressIndicator(value: _progreso),
            const SizedBox(height: 8),
            Text(
              '$porcentaje%',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              _mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Meta: $_meta hábitos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _meta.toDouble(),
              min: 1,
              max: _habitos.length.toDouble(),
              divisions: _habitos.length - 1,
              label: _meta.toString(),
              onChanged: _cambiarMeta,
            ),
            if (_metaAlcanzada)
              const Text(
                'Meta alcanzada',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SwitchListTile(
              title: const Text('Modo enfoque'),
              value: _enfoque,
              onChanged: _alternarEnfoque,
              contentPadding: EdgeInsets.zero,
            ),
            for (int indice = 0; indice < _habitos.length; indice++)
              if (!_enfoque || !_cumplidos[indice])
                CheckboxListTile(
                  title: Text(_habitos[indice]),
                  value: _cumplidos[indice],
                  onChanged: (valor) => _alternarHabito(indice, valor),
                  contentPadding: EdgeInsets.zero,
                ),
            const SizedBox(height: 16),
            TextField(
              controller: _notaCtrl,
              decoration: const InputDecoration(
                labelText: 'Nota del día',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _guardarNota,
              child: const Text('Guardar nota'),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_nota.isEmpty ? 'Sin nota' : _nota),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _reiniciarDia,
              child: const Text('Reiniciar día'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
