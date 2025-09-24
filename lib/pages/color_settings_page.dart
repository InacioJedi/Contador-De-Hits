import 'dart:math' as math;
import 'package:flutter/material.dart';

class ColorSettingsPage extends StatefulWidget {
  const ColorSettingsPage(
      {super.key, required this.initialLeft, required this.initialRight});
  final Color initialLeft;
  final Color initialRight;

  @override
  State<ColorSettingsPage> createState() => _ColorSettingsPageState();
}

class _ColorSettingsPageState extends State<ColorSettingsPage> {
  late Color _leftColor;
  late Color _rightColor;

  static const List<Color> _presetColors = <Color>[
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.black,
    Colors.white,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _leftColor = widget.initialLeft;
    _rightColor = widget.initialRight;
  }

  Future<void> _pickPresetColor({required bool pickLeft}) async {
    final chosen = await showDialog<Color>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        final mq = MediaQuery.of(context);
        final double side =
            (math.min(mq.size.width, mq.size.height) * 0.6).clamp(280.0, 480.0);

        return Center(
          child: SizedBox(
            width: side,
            height: side,
            child: Material(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(pickLeft ? 'Cor da esquerda' : 'Cor da direita',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, box) {
                          const double gap = 14;
                          final double gridW = box.maxWidth;
                          final double gridH = box.maxHeight;
                          final double cellW = (gridW - (gap * 2)) / 3;
                          final double cellH = (gridH - (gap * 2)) / 3;
                          final double ratio = cellW / cellH;

                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _presetColors.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: gap,
                              crossAxisSpacing: gap,
                              childAspectRatio: ratio,
                            ),
                            itemBuilder: (context, i) => _ResponsiveColorDot(
                              color: _presetColors[i],
                              onTap: () => Navigator.pop(context, _presetColors[i]),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (chosen != null) {
      setState(() {
        if (pickLeft) {
          _leftColor = chosen;
        } else {
          _rightColor = chosen;
        }
      });
    }
  }

  void _apply() {
    Navigator.pop<Map<String, Color>>(
        context, {'left': _leftColor, 'right': _rightColor});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alterar cores')),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: Container(color: _leftColor)),
                    Expanded(child: Container(color: _rightColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: _ColorSwatch(preview: _leftColor),
              title: const Text('Lado esquerdo'),
              subtitle: const Text('Toque para escolher a cor'),
              trailing: const Icon(Icons.edit),
              onTap: () => _pickPresetColor(pickLeft: true),
            ),
            ListTile(
              leading: _ColorSwatch(preview: _rightColor),
              title: const Text('Lado direito'),
              subtitle: const Text('Toque para escolher a cor'),
              trailing: const Icon(Icons.edit),
              onTap: () => _pickPresetColor(pickLeft: false),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _apply,
                icon: const Icon(Icons.check),
                label: const Text('Aplicar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.preview});
  final Color preview;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: preview,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
    );
  }
}

class _ResponsiveColorDot extends StatelessWidget {
  const _ResponsiveColorDot({required this.color, required this.onTap});
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final double size = (c.biggest.shortestSide * 0.7).clamp(32.0, 84.0);
        final isWhite = color == Colors.white;
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Material(
              shape: const CircleBorder(),
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(
                        color: isWhite ? Colors.black87 : Colors.black26,
                        width: isWhite ? 2 : 1),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
