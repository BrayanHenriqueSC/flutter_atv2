import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil de Treino',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),      ),
      home: const PerfilTreinoTela(),
    );
  }
}

class PerfilTreinoTela extends StatefulWidget {
  const PerfilTreinoTela({super.key});

  @override
  State<PerfilTreinoTela> createState() => _PerfilTreinoTelaState();
}

class _PerfilTreinoTelaState extends State<PerfilTreinoTela> {
  static const String _objetivoPadrao = 'Emagrecimento';
  static const String _nivelPadrao = 'Iniciante';
  static const double _tempoPadrao = 60;
  static const int _frequenciaPadrao = 3;
  static const bool _notificacaoPadrao = true;
  static const bool _termosPadrao = false;

  static const List<String> _restricoesDisponiveis = [
    'Vegetariano',
    'Vegano',
    'Sem lactose',
    'Sem glúten',
    'Low Carb',
  ];

  late String _objetivoSelecionado;
  late String _nivelSelecionado;
  late List<String> _restricoesSelecionadas;
  late List<String> _alergias;
  late double _tempoSelecionado;
  late int _frequenciaSelecionada;
  late bool _notificacaoAtiva;
  late bool _termosAceitos;

  final TextEditingController _alergiaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _objetivoSelecionado = _objetivoPadrao;
    _nivelSelecionado = _nivelPadrao;
    _restricoesSelecionadas = [];
    _alergias = [];
    _tempoSelecionado = _tempoPadrao;
    _frequenciaSelecionada = _frequenciaPadrao;
    _notificacaoAtiva = _notificacaoPadrao;
    _termosAceitos = _termosPadrao;
  }

  void _adicionarAlergia() {
    String alergia = _alergiaController.text;

    if (alergia.isNotEmpty) {
      if (!_alergias.contains(alergia)) {
        setState(() {
          _alergias.add(alergia);
          _alergiaController.clear();
        });
      }
    }
  }

  void _gerarPlano() {
    if (!_termosAceitos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seu perfil de treino',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Objetivo: $_objetivoSelecionado'),
              Text('Nível: $_nivelSelecionado'),
              Text(
                'Restrições: ${_restricoesSelecionadas.isEmpty ? "Nenhuma" : _restricoesSelecionadas.join(", ")}',
              ),
              Text(
                'Alergias: ${_alergias.isEmpty ? "Nenhuma" : _alergias.join(", ")}',
              ),
              Text('Tempo diário: ${_tempoSelecionado.round()} minutos'),
              Text('Frequência: $_frequenciaSelecionada dias por semana'),
              Text(
                'Notificações: ${_notificacaoAtiva ? "Ativadas" : "Desativadas"}',
              ),
              const Text('Termos: Aceitos'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Montador de Perfil de Treino'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Objetivo do Treino',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Emagrecimento',
                  label: Text('Emagrecimento'),
                ),
                ButtonSegment(
                  value: 'Hipertrofia',
                  label: Text('Hipertrofia'),
                ),
                ButtonSegment(
                  value: 'Condicionamento',
                  label: Text('Condicionamento'),
                ),
              ],
              selected: {_objetivoSelecionado},
              onSelectionChanged: (novoValor) {
                setState(() {
                  _objetivoSelecionado = novoValor.first;
                });
              },
            ),

            const Divider(height: 32),

            Text(
              'Nível de Experiência',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Iniciante'),
                  selected: _nivelSelecionado == 'Iniciante',
                  onSelected: (selecionado) {
                    setState(() {
                      _nivelSelecionado = 'Iniciante';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Intermediário'),
                  selected: _nivelSelecionado == 'Intermediário',
                  onSelected: (selecionado) {
                    setState(() {
                      _nivelSelecionado = 'Intermediário';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Avançado'),
                  selected: _nivelSelecionado == 'Avançado',
                  onSelected: (selecionado) {
                    setState(() {
                      _nivelSelecionado = 'Avançado';
                    });
                  },
                ),
              ],
            ),

            const Divider(height: 32),

            Text(
              'Restrições Alimentares',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _restricoesDisponiveis.map((restricao) {
                final estaSelecionado =
                    _restricoesSelecionadas.contains(restricao);

                return FilterChip(
                  label: Text(restricao),
                  selected: estaSelecionado,
                  onSelected: (selecionado) {
                    setState(() {
                      if (selecionado) {
                        _restricoesSelecionadas.add(restricao);
                      } else {
                        _restricoesSelecionadas.remove(restricao);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const Divider(height: 32),

            Text(
              'Alergias',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _alergiaController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite uma alergia...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _adicionarAlergia,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _alergias.map((alergia) {
                return InputChip(
                  label: Text(alergia),
                  onDeleted: () {
                    setState(() {
                      _alergias.remove(alergia);
                    });
                  },
                );
              }).toList(),
            ),

            const Divider(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tempo Diário',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${_tempoSelecionado.round()} minutos',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: _tempoSelecionado,
              min: 15,
              max: 120,
              divisions: 21,
              label: _tempoSelecionado.round().toString(),
              onChanged: (novoValor) {
                setState(() {
                  _tempoSelecionado = novoValor;
                });
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('15'),
                Text('120'),
              ],
            ),

            const Divider(height: 32),

            Text(
              'Frequência Semanal',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            RadioGroup<int>(
              groupValue: _frequenciaSelecionada,
              onChanged: (int? valor) {
                setState(() {
                  _frequenciaSelecionada = valor!;
                });
              },
              child: const Column(
                children: [
                  ListTile(
                    title: Text('2 dias'),
                    leading: Radio<int>(value: 2),
                  ),
                  ListTile(
                    title: Text('3 dias'),
                    leading: Radio<int>(value: 3),
                  ),
                  ListTile(
                    title: Text('4 dias'),
                    leading: Radio<int>(value: 4),
                  ),
                  ListTile(
                    title: Text('5 dias'),
                    leading: Radio<int>(value: 5),
                  ),
                  ListTile(
                    title: Text('6 dias'),
                    leading: Radio<int>(value: 6),
                  ),
                ],
              ),
            ),

            const Divider(height: 32),

            SwitchListTile(
              title: const Text('Receber notificações para beber água'),
              value: _notificacaoAtiva,
              onChanged: (ativo) {
                setState(() {
                  _notificacaoAtiva = ativo;
                });
              },
            ),

            const Divider(height: 32),

            CheckboxListTile(
              title: const Text(
                'Aceito os termos e condições para geração do plano de treino',
              ),
              value: _termosAceitos,
              onChanged: (marcado) {
                setState(() {
                  _termosAceitos = marcado ?? false;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _gerarPlano,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('GERAR PLANO'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}