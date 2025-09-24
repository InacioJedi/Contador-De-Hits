import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerConfigPage extends StatefulWidget {
  const TimerConfigPage({super.key, required this.initial});
  final Duration initial;

  @override
  State<TimerConfigPage> createState() => _TimerConfigPageState();
}

class _TimerConfigPageState extends State<TimerConfigPage> {
  late final TextEditingController _minCtrl;
  late final TextEditingController _secCtrl;

  @override
  void initState() {
    super.initState();
    _minCtrl = TextEditingController(
      text: widget.initial.inMinutes.remainder(60).toString().padLeft(2, '0'),
    );
    _secCtrl = TextEditingController(
      text: widget.initial.inSeconds.remainder(60).toString().padLeft(2, '0'),
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _secCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    int m = int.tryParse(_minCtrl.text) ?? 0;
    int s = int.tryParse(_secCtrl.text) ?? 0;
    m = m.clamp(0, 59);
    s = s.clamp(0, 59);
    final totalSecs = (m * 60) + s;
    final dur = Duration(seconds: totalSecs == 0 ? 1 : totalSecs);
    Navigator.pop<Duration>(context, dur);
  }

  void _step(TextEditingController c, int delta) {
    final v = (int.tryParse(c.text) ?? 0) + delta;
    c.text = v.clamp(0, 59).toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Definir duração do timer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _apply,
            child: const Text('Aplicar', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Duração', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _NumberField(
                          label: 'Minutos',
                          controller: _minCtrl,
                          onMinus: () => _step(_minCtrl, -1),
                          onPlus:  () => _step(_minCtrl,  1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _NumberField(
                          label: 'Segundos',
                          controller: _secCtrl,
                          onMinus: () => _step(_secCtrl, -1),
                          onPlus:  () => _step(_secCtrl,  1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _apply,
                    icon: const Icon(Icons.check),
                    label: const Text('Aplicar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.controller,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            _SquareButton(icon: Icons.remove, onTap: onMinus),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SquareButton(icon: Icons.add, onTap: onPlus),
          ],
        ),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.85),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
