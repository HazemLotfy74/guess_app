import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
            itemBuilder: (context, index) {
              return const ListTile(
                title: Text("Hazem"),
                trailing: Text("Score"),
              );
            },
          )
        ],
      ),
    );
  }
}
