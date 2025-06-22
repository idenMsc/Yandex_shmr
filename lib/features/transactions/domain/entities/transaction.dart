class Transaction {
  final int id;
  final AccountBrief account;
  final Category category;
  final double amount;
  final DateTime transactionDate;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.account,
    required this.category,
    required this.amount,
    required this.transactionDate,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });
}

class AccountBrief {
  final int id;
  final String name;
  final double balance;
  final String currency;

  AccountBrief({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });
}

class Category {
  final int id;
  final String name;
  final String emoji;
  final bool isIncome;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.isIncome,
  });
}
