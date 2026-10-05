import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanterna Inteligente',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppCores.fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppCores.amarelo,
          brightness: Brightness.dark,
        ),
      ),
      home: const LanternaScreen(),
    );
  }
}

class AppCores {
  static const fundo = Color(0xFF101010);
  static const painel = Color(0xFF1B1B1B);
  static const painelClaro = Color(0xFF252525);
  static const amarelo = Color(0xFFFFD54F);
  static const amareloForte = Color(0xFFFFC107);
  static const texto = Color(0xFFF5F5F5);
  static const cinza = Color(0xFF999999);
  static const verde = Color(0xFF66BB6A);
  static const roxo = Color(0xFF9575CD);
}

class LanternaScreen extends StatefulWidget {
  const LanternaScreen({super.key});

  @override
  State<LanternaScreen> createState() => _LanternaScreenState();
}

class _LanternaScreenState extends State<LanternaScreen> {
  bool lanternaLigada = false;
  bool modoAutomatico = false;

  double intensidade = 70;

  Timer? timer;

  void alternarLanterna() {
    setState(() {
      lanternaLigada = !lanternaLigada;
    });
  }

  void alterarModoAutomatico(bool valor) {
    setState(() {
      modoAutomatico = valor;
    });

    timer?.cancel();

    if (valor) {
      timer = Timer.periodic(
        const Duration(seconds: 4),
        (timer) {
          if (!mounted) return;

          setState(() {
            lanternaLigada = !lanternaLigada;
          });
        },
      );
    }
  }

  String get textoIntensidade {
    if (intensidade <= 30) {
      return 'Baixa';
    }

    if (intensidade <= 70) {
      return 'Média';
    }

    return 'Alta';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brilho = intensidade / 100;

    return Scaffold(
      backgroundColor: AppCores.fundo,

      appBar: AppBar(
        backgroundColor: AppCores.fundo,
        elevation: 0,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(
              Icons.flashlight_on,
              color: AppCores.amarelo,
            ),
            SizedBox(width: 10),
            Text(
              'Lanterna Inteligente',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: lanternaLigada
                  ? AppCores.verde.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: lanternaLigada
                      ? AppCores.verde
                      : AppCores.cinza,
                ),
                const SizedBox(width: 6),
                Text(
                  lanternaLigada ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: lanternaLigada
                        ? AppCores.verde
                        : AppCores.cinza,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
        child: Column(
          children: [
            // --------------------------------------------------
            // PAINEL PRINCIPAL
            // --------------------------------------------------
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppCores.painel,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: lanternaLigada
                      ? AppCores.amarelo.withValues(alpha: 0.5)
                      : AppCores.painelClaro,
                ),
                boxShadow: lanternaLigada
                    ? [
                        BoxShadow(
                          color: AppCores.amarelo.withValues(
                            alpha: 0.12,
                          ),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Iluminação',
                        style: TextStyle(
                          color: AppCores.cinza,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${intensidade.round()}%',
                        style: const TextStyle(
                          color: AppCores.amarelo,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // FEIXE DE LUZ
                  // ------------------------------------------------
                  SizedBox(
                    height: 230,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 170 + (70 * brilho),
                          height: 170 + (70 * brilho),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppCores.amarelo.withValues(
                              alpha: lanternaLigada
                                  ? 0.04 + (brilho * 0.08)
                                  : 0,
                            ),
                          ),
                        ),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          width: 125,
                          height: 125,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: lanternaLigada
                                ? AppCores.amarelo.withValues(
                                    alpha: 0.12 + (brilho * 0.20),
                                  )
                                : AppCores.painelClaro,
                          ),
                          child: Icon(
                            lanternaLigada
                                ? Icons.light_mode
                                : Icons.light_mode_outlined,
                            size: 55,
                            color: lanternaLigada
                                ? AppCores.amarelo
                                : AppCores.cinza,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    lanternaLigada
                        ? 'Iluminação ativa'
                        : 'Iluminação desligada',
                    style: TextStyle(
                      color: lanternaLigada
                          ? AppCores.amarelo
                          : AppCores.cinza,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // CONTROLE DE INTENSIDADE
            // --------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                18,
                16,
                18,
                12,
              ),
              decoration: BoxDecoration(
                color: AppCores.painel,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.brightness_6_outlined,
                        color: AppCores.amarelo,
                        size: 21,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Intensidade',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        textoIntensidade,
                        style: const TextStyle(
                          color: AppCores.cinza,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    value: intensidade,
                    min: 10,
                    max: 100,
                    divisions: 9,
                    activeColor: AppCores.amarelo,
                    inactiveColor: AppCores.painelClaro,
                    label: '${intensidade.round()}%',
                    onChanged: (valor) {
                      setState(() {
                        intensidade = valor;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // MODO AUTOMÁTICO
            // --------------------------------------------------
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: modoAutomatico
                    ? AppCores.roxo.withValues(alpha: 0.12)
                    : AppCores.painel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: modoAutomatico
                      ? AppCores.roxo.withValues(alpha: 0.7)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: modoAutomatico
                          ? AppCores.roxo
                          : AppCores.painelClaro,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 13),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Modo automático',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Alternar a iluminação automaticamente',
                          style: TextStyle(
                            color: AppCores.cinza,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value: modoAutomatico,
                    activeThumbColor: AppCores.roxo,
                    onChanged: alterarModoAutomatico,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // BOTÃO LIGAR / DESLIGAR
            // --------------------------------------------------
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: alternarLanterna,
                style: ElevatedButton.styleFrom(
                  backgroundColor: lanternaLigada
                      ? AppCores.amarelo
                      : AppCores.painelClaro,
                  foregroundColor: lanternaLigada
                      ? Colors.black
                      : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      lanternaLigada
                          ? Icons.flash_off
                          : Icons.flash_on,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      lanternaLigada
                          ? 'DESLIGAR LANTERNA'
                          : 'LIGAR LANTERNA',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
