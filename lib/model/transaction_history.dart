class Transaction {
  final String name;
  final String amount;
  final String category;

  const Transaction({
    this.name,
    this.amount,
    this.category,
  });
}

class TransactionHistory {
  final List<Transaction> yesterday = [];
  final List<Transaction> other = [];

  TransactionHistory() {
    yesterday
    ..add(
      Transaction(
        name: "Netflix",
        amount: "- \$5.00",
        category: "Video",
      )
    )
    ..add(
      Transaction(
        name: "Steak",
        amount: "- \$5.00",
        category: "Food",
      )
    )
    ..add(
      Transaction(
        name: "Spotify",
        amount: "- \$5.00",
        category: "Music",
      )
    );

    other
    ..add(
      Transaction(
        name: "Earth",
        amount: "- \$13.25",
        category: "Other",
      )
    )
    ..add(
      Transaction(
        name: "Water",
        amount: "- \$3.25",
        category: "Other",
      )
    )
    ..add(
      Transaction(
        name: "Fire",
        amount: "- \$10.00",
        category: "Other",
      )
    )
    ..add(
      Transaction(
        name: "Wind",
        amount: "- \$14.95",
        category: "Other",
      )
    );
  }
}
