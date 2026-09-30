import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CadernoDoValeApp());
}

// Aqui fica a configuração principal do aplicativo.
class CadernoDoValeApp extends StatelessWidget {
  const CadernoDoValeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caderno de Campo do Vale',

      // Tira aquela faixa de DEBUG que aparece no canto.
      debugShowCheckedModeBanner: false,

      // Aqui eu defini o tema verde do aplicativo.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
      ),

      // Essa é a primeira tela que vai abrir.
      home: const RegistroChuvaPage(),
    );
  }
}

// Aqui eu formato a data enquanto a pessoa digita.
// As barras são colocadas automaticamente no formato DD/MM/AAAA.
class _DataInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Aqui eu deixo somente os números digitados.
    String numeros = newValue.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    // A data pode ter no máximo 8 números: DDMMAAAA.
    if (numeros.length > 8) {
      numeros = numeros.substring(0, 8);
    }

    String dataFormatada = '';

    if (numeros.length <= 2) {
      dataFormatada = numeros;
    } else if (numeros.length <= 4) {
      dataFormatada =
          '${numeros.substring(0, 2)}/${numeros.substring(2)}';
    } else {
      dataFormatada =
          '${numeros.substring(0, 2)}/${numeros.substring(2, 4)}/${numeros.substring(4)}';
    }

    return TextEditingValue(
      text: dataFormatada,
      selection: TextSelection.collapsed(
        offset: dataFormatada.length,
      ),
    );
  }
}

// Essa classe representa cada registro de chuva.
// Cada registro vai ter uma data e uma quantidade de chuva.
class RegistroChuva {
  final String data;
  final double milimetros;

  RegistroChuva({
    required this.data,
    required this.milimetros,
  });
}

// Essa é a tela principal.
// Usei StatefulWidget porque os dados da tela vão mudar.
class RegistroChuvaPage extends StatefulWidget {
  const RegistroChuvaPage({super.key});

  @override
  State<RegistroChuvaPage> createState() =>
      _RegistroChuvaPageState();
}

class _RegistroChuvaPageState
    extends State<RegistroChuvaPage> {
  // Esses controladores pegam o que o usuário digita nos campos.
  final _dataController = TextEditingController();
  final _chuvaController = TextEditingController();

  // Aqui ficam guardados todos os registros adicionados.
  final List<RegistroChuva> _registros = [];

  // Essa variável guarda uma mensagem de erro quando for necessário.
  String? _erro;

  // Essa mensagem muda enquanto a pessoa digita a quantidade de chuva.
  String _mensagemChuva =
      'Informe a quantidade de chuva medida em milímetros.';

  // Aqui eu calculo o total de chuva de todos os registros.
  // O fold percorre a lista e vai somando os valores.
  double get _totalChuva {
    return _registros.fold(
      0.0,
      (soma, registro) => soma + registro.milimetros,
    );
  }

  // Aqui eu calculo a média de chuva dos registros.
  double get _mediaChuva {
    // Se não tiver nenhum registro, a média fica zero.
    if (_registros.isEmpty) {
      return 0.0;
    }

    return _totalChuva / _registros.length;
  }

  // Essa função verifica o valor da chuva enquanto o usuário digita.
  // Ela é chamada pelo onChanged do campo.
  void _validarEnquantoDigita(String valor) {
    // Troco a vírgula por ponto para conseguir converter o número.
    final texto = valor.trim().replaceAll(',', '.');

    // Tento transformar o texto em número.
    final numero = double.tryParse(texto);

    setState(() {
      if (valor.trim().isEmpty) {
        _mensagemChuva =
            'Informe a quantidade de chuva medida em milímetros.';
      } else if (numero == null) {
        _mensagemChuva =
            'Digite apenas um valor numérico.';
      } else if (numero < 0) {
        _mensagemChuva =
            'A chuva não pode ter valor negativo.';
      } else {
        _mensagemChuva =
            'Leitura válida: ${numero.toStringAsFixed(1)} mm';
      }
    });
  }

  // Essa função adiciona um novo registro na lista.
  void _adicionarRegistro() {
    // Pego a data digitada.
    final data = _dataController.text.trim();

    // Pego a quantidade de chuva digitada.
    final textoChuva =
        _chuvaController.text.trim().replaceAll(',', '.');

    // Tento transformar o valor digitado em número.
    final chuva = double.tryParse(textoChuva);

    // Aqui verifico se a data foi preenchida.
    if (data.isEmpty) {
      setState(() {
        _erro = 'Informe a data da medição.';
      });

      return;
    }

    // Aqui verifico se o valor digitado realmente é um número.
    if (chuva == null) {
      setState(() {
        _erro =
            'Informe um valor numérico válido para a chuva.';
      });

      return;
    }

    // Aqui não deixo colocar chuva negativa.
    if (chuva < 0) {
      setState(() {
        _erro =
            'O valor da chuva não pode ser negativo.';
      });

      return;
    }

    // Se estiver tudo certo, adiciono o registro na lista.
    setState(() {
      _registros.add(
        RegistroChuva(
          data: data,
          milimetros: chuva,
        ),
      );

      // Depois de adicionar, tiro qualquer mensagem de erro.
      _erro = null;

      // Limpo os campos para poder fazer um novo registro.
      _dataController.clear();
      _chuvaController.clear();

      _mensagemChuva =
          'Informe a quantidade de chuva medida em milímetros.';
    });
  }

  // Essa função remove somente um registro da lista.
  void _removerRegistro(int index) {
    setState(() {
      _registros.removeAt(index);
    });
  }

  // Essa função limpa todos os registros e também limpa os campos.
  void _limparTudo() {
    setState(() {
      _registros.clear();

      _erro = null;

      _dataController.clear();
      _chuvaController.clear();

      _mensagemChuva =
          'Informe a quantidade de chuva medida em milímetros.';
    });
  }

  // Essa função deixa o número no formato que quero mostrar na tela.
  String _formatarMm(double valor) {
    return '${valor.toStringAsFixed(1).replaceAll('.', ',')} mm';
  }

  // Aqui libero os controladores quando a tela é fechada.
  @override
  void dispose() {
    _dataController.dispose();
    _chuvaController.dispose();

    super.dispose();
  }

  // A partir daqui começa a parte visual da tela.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra verde na parte de cima.
      appBar: AppBar(
        title: const Text('Registro de Chuva'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),

      // Usei SingleChildScrollView para conseguir rolar a tela.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título da funcionalidade.
            const Text(
              'Caderno de Campo do Vale',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),

            const SizedBox(height: 6),

            // Texto explicando o que essa tela faz.
            const Text(
              'Pluviômetro digital para registros do Vale de São Patrício.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 24),

            // Campo onde o produtor informa a data.
            TextField(
              controller: _dataController,

              // Deixo o teclado preparado para digitar números.
              keyboardType: TextInputType.number,

              // Aqui uso a regra que coloca as barras automaticamente.
              inputFormatters: [
                _DataInputFormatter(),
              ],

              decoration: const InputDecoration(
                labelText: 'Data da medição',
                hintText: 'DD/MM/AAAA',
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Color(0xFF2E7D32),
                ),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Campo onde o produtor informa quantos milímetros choveram.
            TextField(
              controller: _chuvaController,

              // Aqui deixo o teclado preparado para números.
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),

              // O onChanged chama a validação toda vez que o valor muda.
              onChanged: _validarEnquantoDigita,

              decoration: const InputDecoration(
                labelText: 'Chuva medida (mm)',
                hintText: 'Ex.: 12,5',
                prefixIcon: Icon(
                  Icons.water_drop,
                  color: Color(0xFF2E7D32),
                ),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            // Mostra a mensagem de validação do campo de chuva.
            Text(
              _mensagemChuva,
              style: TextStyle(
                color:
                    _mensagemChuva.startsWith('Leitura válida')
                        ? const Color(0xFF2E7D32)
                        : Colors.black54,
              ),
            ),

            // Se existir algum erro, mostro essa caixa vermelha.
            if (_erro != null) ...[
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFC62828),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        _erro!,
                        style: const TextStyle(
                          color: Color(0xFFC62828),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Aqui fica o botão principal para registrar a chuva.
            FilledButton.icon(
              onPressed: _adicionarRegistro,
              icon: const Icon(Icons.add),
              label: const Text('Registrar chuva'),
              style: FilledButton.styleFrom(
                backgroundColor:
                    const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Resumo do período',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),

            const SizedBox(height: 12),

            // Aqui mostro o total e a média lado a lado.
            Row(
              children: [
                Expanded(
                  child: _CardResumo(
                    titulo: 'Acumulado',
                    valor: _formatarMm(_totalChuva),
                    icone: Icons.water,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _CardResumo(
                    titulo: 'Média',
                    valor: _formatarMm(_mediaChuva),
                    icone: Icons.analytics_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Aqui fica o título da lista e o botão para limpar.
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Registros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),

                // Mostra quantos registros já foram feitos.
                Text(
                  '${_registros.length} registro(s)',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(width: 12),

                // O botão fica perto da lista porque limpa os registros.
                OutlinedButton.icon(
                  onPressed:
                      _registros.isEmpty ? null : _limparTudo,
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                  ),
                  label: const Text('Limpar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Se não tiver nenhum registro, aparece essa mensagem.
            if (_registros.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  border: Border.all(
                    color: const Color(0xFFA5D6A7),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Nenhuma medição registrada ainda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              )

            // Se tiver registros, monto a lista.
            else
              ListView.separated(
                shrinkWrap: true,

                // A rolagem fica por conta da tela principal.
                physics:
                    const NeverScrollableScrollPhysics(),

                itemCount: _registros.length,

                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },

                itemBuilder: (context, index) {
                  // Pego o registro daquela posição.
                  final registro = _registros[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFC8E6C9),
                      ),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),

                    child: Row(
                      children: [
                        // Ícone da chuva.
                        const CircleAvatar(
                          backgroundColor:
                              Color(0xFFE8F5E9),
                          child: Icon(
                            Icons.water_drop,
                            color: Color(0xFF2E7D32),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Aqui mostro a data e a quantidade de chuva.
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                registro.data,
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                _formatarMm(
                                  registro.milimetros,
                                ),
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Esse botão remove somente aquele registro.
                        IconButton(
                          onPressed: () {
                            _removerRegistro(index);
                          },
                          tooltip: 'Remover registro',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Criei esse widget separado para não repetir o mesmo código
// nos cartões de acumulado e média.
class _CardResumo extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;

  const _CardResumo({
    required this.titulo,
    required this.valor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      // Fundo verde claro para destacar os resultados.
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFA5D6A7),
        ),
      ),

      child: Column(
        children: [
          Icon(
            icone,
            color: const Color(0xFF2E7D32),
            size: 28,
          ),

          const SizedBox(height: 8),

          Text(
            titulo,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }
}