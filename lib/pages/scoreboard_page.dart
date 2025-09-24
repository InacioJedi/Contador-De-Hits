import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/edit_names_page.dart';
import '../pages/color_settings_page.dart';
import '../pages/finalize_fight_page.dart';
import '../pages/regras_robocore_page.dart';
import '../pages/timer_config_page.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/half_pane.dart';
import '../widgets/top_pill_button.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});
  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  // Cores e nomes
  Color leftColor = Colors.blue;
  Color rightColor = Colors.yellow;
  String leftName = 'Robo 1';
  String rightName = 'Robo 2';

  // Placar (HITS)
  int left = 0;
  int right = 0;

  // Timer
  Duration _timerTotal = const Duration(minutes: 2);
  Duration _timeLeft = const Duration(minutes: 2);
  Timer? _countdown;
  bool _running = false;

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _tick(Timer t) {
    if (_timeLeft.inSeconds <= 0) {
      _stopTimer(reset: false);
      HapticFeedback.heavyImpact();
      return;
    }
    setState(() => _timeLeft -= const Duration(seconds: 1));
  }

  void _startPauseTimer() {
    if (_running) {
      _stopTimer(reset: false);
    } else {
      _countdown = Timer.periodic(const Duration(seconds: 1), _tick);
      setState(() => _running = true);
    }
  }

  void _stopTimer({required bool reset}) {
    _countdown?.cancel();
    _countdown = null;
    setState(() {
      _running = false;
      if (reset) _timeLeft = _timerTotal;
    });
  }

  // PÁGINA: configurar timer
  Future<void> _openTimerConfigPage() async {
    final result = await Navigator.of(context).push<Duration>(
      MaterialPageRoute(
        builder: (_) => TimerConfigPage(initial: _timerTotal),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      _stopTimer(reset: false);
      setState(() {
        _timerTotal = result;
        _timeLeft = result;
      });
    }
  }

  void _resetScores() => setState(() {
        left = 0;
        right = 0;
      });

  void _openActionsSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline),
            title: const Text('Alterar nomes'),
            onTap: () async {
              Navigator.pop(context);
              await _goToEditNamesPage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Alterar cores'),
            onTap: () async {
              Navigator.pop(context);
              await _goToColorSettingsPage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Definir duração do timer'),
            onTap: () async {
              Navigator.pop(context);
              await _openTimerConfigPage();
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.rule),
            title: const Text('Regras Robocore'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegrasRobocorePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Resetar Placar'),
            onTap: () {
              Navigator.pop(context);
              _resetScores();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _goToColorSettingsPage() async {
    final result = await Navigator.of(context).push<Map<String, Color>>(
      MaterialPageRoute(
        builder: (_) => ColorSettingsPage(
          initialLeft: leftColor,
          initialRight: rightColor,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        leftColor = result['left'] ?? leftColor;
        rightColor = result['right'] ?? rightColor;
      });
    }
  }

  // PÁGINA: editar nomes
  Future<void> _goToEditNamesPage() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) => EditNamesPage(
          initialLeft: leftName,
          initialRight: rightName,
        ),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      setState(() {
        final l = result['left']?.trim();
        final r = result['right']?.trim();
        leftName = (l == null || l.isEmpty) ? 'Robo 1' : l;
        rightName = (r == null || r.isEmpty) ? 'Robo 2' : r;
      });
    }
  }

  void _goToFinalizeFight() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FinalizeFightPage(
          leftHits: left,
          rightHits: right,
          leftColor: leftColor,
          rightColor: rightColor,
          leftName: leftName,
          rightName: rightName,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countdown?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerChip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _format(_timeLeft),
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // metades clicáveis (+1)
          Row(
            children: [
              Expanded(
                child: Material(
                  color: leftColor,
                  child: InkWell(
                    onTap: () => setState(() => left++),
                    child: HalfPane(centerLabel: '+1', name: leftName),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: rightColor,
                  child: InkWell(
                    onTap: () => setState(() => right++),
                    child: HalfPane(centerLabel: '+1', name: rightName),
                  ),
                ),
              ),
            ],
          ),

          // TOPO — timer + ações
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              height: 56,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoundIconButton(
                        icon: _running ? Icons.pause : Icons.play_arrow,
                        onTap: _startPauseTimer,
                      ),
                      const SizedBox(width: 10),
                      timerChip,
                      const SizedBox(width: 10),
                      RoundIconButton(
                        icon: Icons.refresh,
                        onTap: () => _stopTimer(reset: true),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.85),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                              onPressed: () {
                                if (left == right) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const _EmpateDialog(),
                                  );
                                  return;
                                }
                                _goToFinalizeFight();
                              },
                              child: const Text('Finalizar luta'),
                            ),
                            const SizedBox(width: 8),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: _openActionsSheet,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.menu,
                                      size: 28, color: Colors.black),
                                ),
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
          ),

          // botões -1 cantos inferiores
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TopPillButton(
                      text: '−1',
                      onTap: () =>
                          setState(() => left = (left > 0) ? left - 1 : 0),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TopPillButton(
                      text: '−1',
                      onTap: () =>
                          setState(() => right = (right > 0) ? right - 1 : 0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // placar grande no rodapé
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$left   -   $right',
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmpateDialog extends StatelessWidget {
  const _EmpateDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Caso de Empate na Contabilização de HITS'),
      content: const Text(
        'Caso o round termine com a contabilização de HITs empatada, a definição do '
        'vencedor ficará sob responsabilidade do jurado através da aplicação de 1 ponto '
        'de HIT em favor daquele que tiver desempenhado maior controle ou domínio da partida.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendi'),
        ),
      ],
    );
  }
}
