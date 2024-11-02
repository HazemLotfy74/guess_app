import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guess_app/core.dart';
import 'package:guess_app/players_model.dart';

// ignore: must_be_immutable
class ScoreBoard extends StatelessWidget {
  final sortedPlayers = <Player>[];

  ScoreBoard({super.key});

  var players = <Player>[].obs;

  var asscendingSort = false;
  var asscendingSortNum = false;

  @override
  Widget build(BuildContext context) {
    final main = Get.arguments as List<Player>;
    players.value = main;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'ScoreBoard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (name) {
                      final p = main
                          .where((player) => player.name.contains(name))
                          .toList();
                      players.value = p;
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.mainColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search)),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (asscendingSort) {
                      final p = players
                          .sortedByDescending(
                            (player) => player.name,
                          )
                          .toList();
                      players.value = p;
                      asscendingSort = false;
                    } else {
                      final p = players
                          .sortedBy(
                            (player) => player.name,
                          )
                          .toList();
                      players.value = p;
                      asscendingSort = true;
                    }
                  },
                  icon: const Icon(
                    Icons.sort_by_alpha_rounded,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.mainColor),
                      shape: const WidgetStatePropertyAll(CircleBorder())),
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () {
                    if (asscendingSortNum) {
                      final p = players
                          .sortedByDescending(
                            (player) => player.score,
                          )
                          .toList();
                      players.value = p;
                      asscendingSortNum = false;
                    } else {
                      final p = players
                          .sortedBy(
                            (player) => player.score,
                          )
                          .toList();
                      players.value = p;
                      asscendingSortNum = true;
                    }
                  },
                  icon: const Icon(
                    Icons.format_list_numbered_rounded,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.mainColor),
                    shape: const WidgetStatePropertyAll(
                      CircleBorder(),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: players.isEmpty
                ? const Center(
                    child: Text(
                      "No Players founds",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )
                : Obx(() {
                    return ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.thirdColor),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.thirdColor),
                            child: ListTile(
                              leading: const Icon(
                                Icons.account_circle_rounded,
                                color: Colors.black,
                              ),
                              title: Text(
                                players[index].name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              trailing: Text(
                                players[index].score.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
          )
        ],
      ),
    );
  }
}
