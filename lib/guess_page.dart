import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:guess_app/core.dart';
import 'package:guess_app/players_model.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  final numbers = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];

  FlutterTts? tts = FlutterTts();

  final cont = <RxString>[].obs;

  final guessText = ''.obs;

  int guessNumber = 0;

  final resultTxt = ''.obs;

  final buttonClicked = List.generate(
    9,
    (index) => false,
  ).obs;
  int tries = 0;
  final score = 0.obs;
  final start = false.obs;

  final rightAnswer = false.obs;

  final soundClick = false.obs;

  @override
  Widget build(BuildContext context) {
    cont.addAll(List.generate(numbers.length, (_) => 'Guess'.obs));
    final List<Player> players = Get.arguments;
    final name = players[players.length - 1].name;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Let's go $name",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: () {
            if (!soundClick.value) {
              soundClick.value = true;
            } else {
              soundClick.value = false;
            }
          }, icon: Obx(() {
            return Icon(soundClick.value ? Icons.volume_up : Icons.volume_off);
          }))
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$resultTxt",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: rightAnswer.value ? Colors.green : Colors.red),
                    ),
                    Text(
                      "Score:$score",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                );
              }),
              const SizedBox(
                height: 50,
              ),
              Expanded(child: buildGridView(players, name)),
              Obx(() {
                return Text(
                  "$guessText",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                );
              }),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  gameStart();
                },
                label: const Text(
                  "Guess Number",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll(10),
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.mainColor)),
              )
            ],
          ),
        ),
      ),
    );
  }

  GridView buildGridView(List<Player> players, String name) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return Obx(() {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fourthColor
                // backgroundColor: buttonClicked[index] ? Colors.green : Colors.red
                ),
            onPressed: start.value && buttonClicked[index] == false
                ? () {
                    clickButton(index, players, name);
                  }
                : null,
            child: Obx(() {
              return Text(
                cont[index].value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              );
            }),
          );
        });
      },
      itemCount: numbers.length,
    );
  }

  void gameStart() {
    resultTxt.value = '';
    resultTxt.value = '';
    Random r = Random();
    numbers.shuffle();
    tries = 0;
    rightAnswer.value = false;
    guessNumber = r.nextInt(9) + 1;
    guessText.value = 'Guess : $guessNumber ?';
    start.value = true;

    for (int i = 0; i < numbers.length; i++) {
      cont[i].value = 'Guess';
      buttonClicked[i] = false;
    }
  }

  void clickButton(int index, List<Player> players, String name) {
    if (soundClick.value) {
      speak(index);
    }
    cont[index].value = numbers[index].toString();
    int number = int.parse(cont[index].value);
    tries++;
    if (number == guessNumber) {
      score.value++;
      resultTxt.value = 'Correct,Bravo';
      start.value = false;
      rightAnswer.value = true;
      Player? p = players.firstWhere(
        (player) => player.name == name,
      );
      p.score = score.value;
    } else {
      resultTxt.value = 'Oops,Wrong';
      rightAnswer.value = false;
    }
    buttonClicked[index] = true;

    if (tries == 3) {
      start.value = false;
    }
  }

  Future<void> speak(index) async {
    await tts!.speak(numbers[index].toString());
  }

  stop() async {
    await tts!.stop();
  }
}
