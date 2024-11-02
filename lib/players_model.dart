// class Players {
//   String _name;
//   int _score;
//
//   Players(this._name, this._score);
//
//   String get name => _name;
//
//   set name(String value) {
//     _name = value;
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Players &&
//           runtimeType == other.runtimeType &&
//           _name == other._name;
//
//   @override
//   int get hashCode => _name.hashCode;
//
//   int get score => _score;
//
//   set score(int value) {
//     _score = value;
//   }
// }
class Player {
  String name;
  int score;

  Player({required this.name, required this.score});

  Player.empty()
      : name = '',
        score = 0; // Empty constructor

  // Getter and Setter
  String get playerName => name;
  set playerName(String newName) => name = newName;

  int get playerScore => score;
  set playerScore(int newScore) => score = newScore;

  // equals method for comparing players based on their names
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
