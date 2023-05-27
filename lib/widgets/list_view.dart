import 'package:flutter/material.dart';

class ListViewPadrao extends StatelessWidget {
  final List<String> items;

  ListViewPadrao({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Cria um item de lista personalizado para cada elemento
        return ListTile(
          title: Text(items[index]),
          onTap: () {
            // Lógica ao clicar no item da lista
            print('Item selecionado: ${items[index]}');
          },
        );
      },
    );
  }
}
