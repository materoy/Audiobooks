import 'package:equatable/equatable.dart';

class Shelf extends Equatable {
  const Shelf(
      {required this.shelfId,
      required this.shelfName,
      required this.rank,
      required this.numberOf,
      this.shelfIcon});

  final int shelfId;
  final String shelfName;
  final int rank;
  final int numberOf;
  final String? shelfIcon;
  @override
  List<Object?> get props => [shelfName, rank, numberOf];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'shelfId': shelfId,
      'shelfName': shelfName,
      'rank': rank,
      'numberOf': numberOf,
      'shelfIcon': shelfIcon,
    };
  }

  factory Shelf.fromMap(Map<String, dynamic> shelfMap) {
    return Shelf(
      shelfId: shelfMap['shelfId'],
      shelfName: shelfMap['shelfName'],
      rank: shelfMap['rank'],
      numberOf: shelfMap['numberOf'],
      shelfIcon: shelfMap['shelfIcon'],
    );
  }
}
