import 'package:equatable/equatable.dart';

class Shelf extends Equatable {
  const Shelf(
      {required this.shelfId,
      required this.shelfName,
      required this.rank,
      required this.amount,
      this.shelfIcon});

  final int shelfId;
  final String shelfName;
  final int rank;
  final int amount;
  final String? shelfIcon;
  @override
  List<Object?> get props => [shelfName, rank, amount];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'shelfId': shelfId,
      'shelfName': shelfName,
      'rank': rank,
      'amount': amount,
      'shelfIcon': shelfIcon,
    };
  }

  factory Shelf.fromMap(Map<String, dynamic> shelfMap) {
    return Shelf(
      shelfId: shelfMap['shelfId'],
      shelfName: shelfMap['shelfName'],
      rank: shelfMap['rank'],
      amount: shelfMap['amount'],
      shelfIcon: shelfMap['shelfIcon'],
    );
  }
}
