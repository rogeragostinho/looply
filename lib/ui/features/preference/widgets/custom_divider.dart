import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1, // espessura da linha
      height: 20, // espaço vertical total ocupado (linha incluída)
      indent: 16, // espaço à esquerda antes da linha começar
      endIndent: 16, // espaço à direita onde a linha termina
      color: const Color.fromARGB(68, 158, 158, 158), // cor da linha
    );
  }
}
