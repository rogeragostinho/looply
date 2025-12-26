import 'package:flutter/material.dart';

class AppBottomAppBar extends StatelessWidget {
  const AppBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 80.0,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(onPressed: () => {}, child: Icon(Icons.home)),
          ElevatedButton(onPressed: () => {}, child: Icon(Icons.topic)),
          FloatingActionButton(
            
            onPressed: () => {},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          ElevatedButton(onPressed: () => {}, child: Icon(Icons.calendar_month)),
          ElevatedButton(onPressed: () => {}, child: Icon(Icons.account_balance)),
        ],
      )
    );
  }
}