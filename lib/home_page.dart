import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guess_app/core.dart';
import 'package:guess_app/guess_page.dart';
import 'package:guess_app/players_model.dart';
import 'package:guess_app/score_board.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final playerName = TextEditingController();

  final players = <Player>[].obs;

  final button = ''.obs;

  final file = GetStorage();

  final lastWinner = ''.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final winner = file.read('winner');
    if (winner != null) {
      lastWinner.value = winner;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final playerWinner = players.maxBy((player) => player.score);
    file.write("winner", playerWinner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello Let's Play",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              onChanged: (value) => button.value = value,
              controller: playerName,
              decoration: InputDecoration(
                  hintText: "Enter Your Name",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mainColor)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.mainColor))),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return ElevatedButton.icon(
                onPressed: button.value.isNotEmpty
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
                label: const Text(
                  "Play",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll(10),
                    backgroundColor: WidgetStatePropertyAll(
                        button.value.isNotEmpty ? AppColors.mainColor : null)),
              );
            }),
            const SizedBox(
              height: 15,
            ),
            Obx(() {
              return ElevatedButton.icon(
                onPressed: players.isNotEmpty
                    ? () {
                        final playerWinner =
                            players.maxBy((player) => player.score);
                        file.write("winner", playerWinner!.name);
                        Get.to(ScoreBoard(), arguments: players);
                      }
                    : null,
                label: const Text(
                  "Scoreboard",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.scoreboard_sharp,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: WidgetStatePropertyAll(
                      players.isNotEmpty ? AppColors.mainColor : null),
                ),
              );
            }),
            const Spacer(),
            lastWinner.value.isNotEmpty
                ? Obx(() {
                    return Card(
                      elevation: 10,
                      shape: const RoundedRectangleBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/trophy.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "The last winner is $lastWinner",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  })
                : const Text('')
          ],
        ),
      ),
    );
  }
}
