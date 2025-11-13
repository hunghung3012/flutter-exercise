class Expense {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  // Chuyển đổi từ Map sang Expense
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }

  // Chuyển đổi từ Expense sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  // Các danh mục chi tiêu
  static List<String> categories = [
    'Ăn uống',
    'Di chuyển',
    'Mua sắm',
    'Giải trí',
    'Sức khỏe',
    'Học tập',
    'Hóa đơn',
    'Khác',
  ];

  // Icon cho từng danh mục
  static String getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return '🍔';
      case 'Di chuyển':
        return '🚗';
      case 'Mua sắm':
        return '🛍️';
      case 'Giải trí':
        return '🎮';
      case 'Sức khỏe':
        return '💊';
      case 'Học tập':
        return '📚';
      case 'Hóa đơn':
        return '📄';
      default:
        return '💰';
    }
  }
}