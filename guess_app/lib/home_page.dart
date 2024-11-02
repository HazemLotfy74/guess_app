import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guess_app/guess_page.dart';
import 'package:guess_app/players_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final playerName = TextEditingController();

  final players = <Player>[].obs;
  final button = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Guess The Number !!",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => button.value = value,
              controller: playerName,
              decoration: InputDecoration(
                  hintText: "Enter Your Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return ElevatedButton.icon(
                onPressed: button.value.isEmpty
                    ? () {
                        String name = playerName.text.toLowerCase();
                        if (players
                            .any((Player player) => player.name == name)) {
                          Get.snackbar("OOPS",
                              "This name is taken please choose another name!");
                        } else {
                          players.add(Player(name: playerName.text, score: 0));
                          Get.to(const GuessPage(), arguments: players);
                        }
                      }
                    : null,
                label: const Text("Play"),
                icon: const Icon(Icons.play_circle),
              );
            }),
          ],
        ),
      ),
    );
  }
}
