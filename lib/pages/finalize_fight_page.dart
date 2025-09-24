import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'damage_classification_page.dart';

enum DamageLevel { trivial, cosmetico, menor, significativo, maior, massivo }

String damageLabel(DamageLevel d) {
  switch (d) {
    case DamageLevel.trivial:
      return 'Trivial';
    case DamageLevel.cosmetico:
      return 'Cosmético';
    case DamageLevel.menor:
      return 'Menor';
    case DamageLevel.significativo:
      return 'Significativo';
    case DamageLevel.maior:
      return 'Maior';
    case DamageLevel.massivo:
      return 'Massivo';
  }
}

class FinalizeFightPage extends StatefulWidget {
  const FinalizeFightPage({
    super.key,
    required this.leftHits,
    required this.rightHits,
    required this.leftColor,
    required this.rightColor,
    required this.leftName,
    required this.rightName,
  });

  final int leftHits;
  final int rightHits;
  final Color leftColor;
  final Color rightColor;
  final String leftName;
  final String rightName;

  @override
  State<FinalizeFightPage> createState() => _FinalizeFightPageState();
}

class _FinalizeFightPageState extends State<FinalizeFightPage> {
  DamageLevel _leftDamage = DamageLevel.trivial;
  DamageLevel _rightDamage = DamageLevel.trivial;

  static const Map<DamageLevel, Map<DamageLevel, (int, int)>> _damageMatrix = {
    DamageLevel.trivial: {
      DamageLevel.trivial: (9, 9),
      DamageLevel.cosmetico: (10, 8),
      DamageLevel.menor: (12, 6),
      DamageLevel.significativo: (14, 4),
      DamageLevel.maior: (16, 2),
      DamageLevel.massivo: (18, 0),
    },
    DamageLevel.cosmetico: {
      DamageLevel.trivial: (8, 10),
      DamageLevel.cosmetico: (9, 9),
      DamageLevel.menor: (10, 8),
      DamageLevel.significativo: (12, 6),
      DamageLevel.maior: (14, 4),
      DamageLevel.massivo: (17, 1),
    },
    DamageLevel.menor: {
      DamageLevel.trivial: (6, 12),
      DamageLevel.cosmetico: (8, 10),
      DamageLevel.menor: (9, 9),
      DamageLevel.significativo: (11, 7),
      DamageLevel.maior: (13, 5),
      DamageLevel.massivo: (15, 3),
    },
    DamageLevel.significativo: {
      DamageLevel.trivial: (4, 14),
      DamageLevel.cosmetico: (6, 12),
      DamageLevel.menor: (7, 11),
      DamageLevel.significativo: (9, 9),
      DamageLevel.maior: (11, 7),
      DamageLevel.massivo: (13, 5),
    },
    DamageLevel.maior: {
      DamageLevel.trivial: (2, 16),
      DamageLevel.cosmetico: (4, 14),
      DamageLevel.menor: (5, 13),
      DamageLevel.significativo: (7, 11),
      DamageLevel.maior: (9, 9),
      DamageLevel.massivo: (11, 7),
    },
    DamageLevel.massivo: {
      DamageLevel.trivial: (0, 18),
      DamageLevel.cosmetico: (1, 17),
      DamageLevel.menor: (3, 15),
      DamageLevel.significativo: (5, 13),
      DamageLevel.maior: (7, 11),
      DamageLevel.massivo: (9, 9),
    },
  };

  (int, int) _hitsAggPoints(int l, int r) {
    if (l == r) return (0, 0);
    final total = (l + r).toDouble();
    final max = math.max(l, r).toDouble();
    final pct = max / total;
    (int, int) perJudge;
    if (pct >= 0.90) {
      perJudge = (5, 0);
    } else if (pct >= 0.80) {
      perJudge = (4, 1);
    } else {
      perJudge = (3, 2);
    }
    final winnerLeft = l > r;
    return winnerLeft
        ? (perJudge.$1 * 3, perJudge.$2 * 3)
        : (perJudge.$2 * 3, perJudge.$1 * 3);
  }

  @override
  Widget build(BuildContext context) {
    final damageScore = _damageMatrix[_leftDamage]![_rightDamage]!;
    final hitsScore = (widget.leftHits == widget.rightHits)
        ? (0, 0)
        : _hitsAggPoints(widget.leftHits, widget.rightHits);

    final totalL = damageScore.$1 + hitsScore.$1;
    final totalR = damageScore.$2 + hitsScore.$2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar luta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ScoreHeaderBar(
            left: widget.leftHits,
            right: widget.rightHits,
            leftColor: widget.leftColor,
            rightColor: widget.rightColor,
            leftName: widget.leftName,
            rightName: widget.rightName,
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              widget.leftHits == widget.rightHits
                  ? 'Agressividade pelos hits: empate'
                  : 'Agressividade pelos hits (3 juízes): ${hitsScore.$1} - ${hitsScore.$2}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dano (escolha o nível de cada robô)',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DamageDropdownCard(
                        title: 'Dano sofrido — ${widget.leftName}',
                        value: _leftDamage,
                        onChanged: (v) => setState(() => _leftDamage = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DamageDropdownCard(
                        title: 'Dano sofrido — ${widget.rightName}',
                        value: _rightDamage,
                        onChanged: (v) => setState(() => _rightDamage = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Pontuação de dano: ${damageScore.$1} - ${damageScore.$2}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Resumo final',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Dano: ${damageScore.$1} - ${damageScore.$2}'),
                Text('Agressividade (hits): ${hitsScore.$1} - ${hitsScore.$2}'),
                const Divider(),
                Text('Total: $totalL - $totalR',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const DamageClassificationPage()),
              );
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('Classificação dos Níveis de Dano'),
          ),
        ],
      ),
    );
  }
}

class _ScoreHeaderBar extends StatelessWidget {
  const _ScoreHeaderBar({
    required this.left,
    required this.right,
    required this.leftColor,
    required this.rightColor,
    required this.leftName,
    required this.rightName,
  });

  final int left;
  final int right;
  final Color leftColor;
  final Color rightColor;
  final String leftName;
  final String rightName;

  @override
  Widget build(BuildContext context) {
    const numStyle =
        TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.w700);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 96,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: leftColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$left', style: numStyle),
                        const SizedBox(height: 4),
                        Text(leftName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: rightColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$right', style: numStyle),
                        const SizedBox(height: 4),
                        Text(rightName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Text('-', style: TextStyle(fontSize: 40, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _DamageDropdownCard extends StatelessWidget {
  const _DamageDropdownCard({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final DamageLevel value;
  final ValueChanged<DamageLevel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<DamageLevel>(
          value: value,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: DamageLevel.values
              .map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(damageLabel(d)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
