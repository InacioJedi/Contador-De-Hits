import 'package:flutter/material.dart';

class EditNamesPage extends StatefulWidget {
  const EditNamesPage({
    super.key,
    required this.initialLeft,
    required this.initialRight,
  });
  final String initialLeft;
  final String initialRight;

  @override
  State<EditNamesPage> createState() => _EditNamesPageState();
}

class _EditNamesPageState extends State<EditNamesPage> {
  late final TextEditingController _leftCtrl;
  late final TextEditingController _rightCtrl;

  final _scroll = ScrollController();
  final _leftFocus = FocusNode();
  final _rightFocus = FocusNode();

  final _leftKey  = GlobalKey();
  final _rightKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _leftCtrl  = TextEditingController(text: widget.initialLeft);
    _rightCtrl = TextEditingController(text: widget.initialRight);
    _leftFocus.addListener(() => _ensureVisible(_leftKey));
    _rightFocus.addListener(() => _ensureVisible(_rightKey));
  }

  @override
  void dispose() {
    _leftCtrl.dispose();
    _rightCtrl.dispose();
    _leftFocus.dispose();
    _rightFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ensureVisible(GlobalKey key) {
    if (!(key.currentContext?.mounted ?? false)) return;
    Future.delayed(const Duration(milliseconds: 150), () {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 250),
          alignment: 0.15,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _apply() {
    Navigator.pop<Map<String, String>>(context, {
      'left':  _leftCtrl.text.trim().isEmpty  ? 'Robo 1' : _leftCtrl.text.trim(),
      'right': _rightCtrl.text.trim().isEmpty ? 'Robo 2' : _rightCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: SingleChildScrollView(
                    controller: _scroll,
                    padding: EdgeInsets.fromLTRB(
                      16, 16, 16,
                      120 + bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Alterar nomes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                        TextField(
                          key: _leftKey,
                          focusNode: _leftFocus,
                          controller: _leftCtrl,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: 'Nome da esquerda',
                            border: OutlineInputBorder(),
                          ),
                          autofocus: true,
                          onSubmitted: (_) => _rightFocus.requestFocus(),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          key: _rightKey,
                          focusNode: _rightFocus,
                          controller: _rightCtrl,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: 'Nome da direita',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _apply(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _apply,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Aplicar',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
