import 'package:flutter/material.dart';

class DamageClassificationPage extends StatelessWidget {
  const DamageClassificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    const text = '''
● Trivial
O nível “Trivial” pode ser considerado como a linha base (nível ZERO), ou seja,
durante o round o robô combatente não sofreu nenhum tipo de DANO que será
contabilizado pelos jurados.
Arranhões visíveis na armadura, rasgos e perda de adesivos ou remoção da
pintura, pequenos cortes ou entalhes não penetrantes no robô irão se enquadrar neste
nível do critério de DANO. Ou seja, não serão contabilizados como DANO para
mudança de nível do critério.

● Cosmético
O nível “Cosmético” é o primeiro nível de DANO real que será contabilizado pelos
juízes após a finalização do round.
Serão considerados neste nível os seguintes DANOS: remoção de peças
cosméticas não estruturais e não cruciais para o pleno funcionamento do robô
combatente.
Exemplos: perda de itens decorativos (exceto adesivos e pintura), iluminação, dano
nas rodas ou em outra parte móvel exposta não resultando em perda de
funcionalidade ou mobilidade do robô.

● Menor
O nível “Menor” é o segundo nível de DANO real que será contabilizado pelos jurados
após a finalização do round. Neste nível serão considerados os DANOS sofridos
durante o round, porém, os mesmos não afetam as funcionalidades principais do robô.
Serão considerados neste nível os seguintes DANOS:
- Fumaça intermitente não associada a queda de potência perceptível.
- Amassamentos significativos ou cortes penetrantes na estrutura do robô sem que
os mesmos afetem de alguma forma o pleno funcionamento do robô combatente.
- Remoção completa de uma roda ou mais, porém sem afetar a mobilidade do robô
combatente.
- Remoção de componentes de uma estrutura ablativa ou de outros componentes da
arma sem resultar em perda de funcionalidade.
- Estruturas apresentando empenamentos, porém sem resultar em perda de
mobilidade ou função da arma do robô combatente.

● Significativo
O nível “Significativo” é o terceiro nível de DANO real que será contabilizado pelos
jurados após a finalização do round. Neste nível serão considerados os DANOS que
reduzem parcialmente as funcionalidades do robô.
Serão considerados neste nível os seguintes DANOS:
- Fumaça contínua, ou fumaça associada à perda parcial de potência do sistema
de locomoção ou das armas.
- Armaduras rasgadas de forma que reduzam as funcionalidades do robô.
- Dano ao sistema de locomoção que cause perda parcial de mobilidade.
- Danos à arma rotativa, resultando em perda de velocidade da arma ou vibração
severa.
- Danos ao braço, martelo ou outra parte móvel de um sistema de arma resultando
em perda parcial da sua funcionalidade.
- Empenamentos em eixos, rampas, forks ou outros componentes de ataque de
robôs que não possuam armas ativas de forma que cause uma perda parcial de
suas funcionalidades.
- Estrutura do robô visivelmente empenada ou deformada de forma que reduza
suas funcionalidades.

● Maior
O nível “Maior” é o quarto nível de DANO real que será contabilizado pelos jurados
após a finalização do round. Neste nível serão considerados os DANOS que são
completamente críticos para as funcionalidades do robô.
Serão considerados neste nível os seguintes DANOS:
- Fogo visível associado a perda total do sistema das armas ou da mobilidade
controlada.
- Seção de armadura completamente removida, expondo os componentes
internos.
- Perda total da funcionalidade de sistemas de armas ativas.
- Dano ao sistema de locomoção que cause perda da mobilidade controlada do
robô.
- Remoção completa de rampas, forks ou outros componentes de ataque de robôs
que não possuam armas ativas.
- Componentes internos arrancados ou que estejam arrastando no chão da arena.
- Vazamento significativo de fluido hidráulico.
- Vazamentos de gases pneumáticos.

● Massivo
O nível “Massivo” é o quinto e último nível de DANO real que será contabilizado
pelos jurados após a finalização do round. Nesse nível serão considerados os danos
que causam total imobilização do robô nos últimos 10 segundos sem que tenha tempo
hábil para início da contagem para nocaute.
Serão considerados neste nível os seguintes DANOS:
- Perda total do sistema de locomoção.
- Perda total de potência do robô.
''';

    return Scaffold(
      appBar: AppBar(title: const Text('Classificação dos Níveis de Dano')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Text(text)),
      ),
    );
  }
}
