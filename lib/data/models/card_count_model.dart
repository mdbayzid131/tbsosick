class CardCountModel {
  final int allCardsCount;
  final int myCardsCount;

  CardCountModel({
    required this.allCardsCount,
    required this.myCardsCount,
  });

  factory CardCountModel.fromJson(Map<String, dynamic> json) {
    return CardCountModel(
      allCardsCount: json['AllCardsCount'] ?? 0,
      myCardsCount: json['myCardsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AllCardsCount': allCardsCount,
      'myCardsCount': myCardsCount,
    };
  }
}
