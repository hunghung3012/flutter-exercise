import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/expense_database.dart';

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final Color primary = const Color(0xFF53B175);
  final Color primaryDark = const Color(0xFF3D8A5A);
  final Color primaryLight = const Color(0xFF6FD99A);

  List<Expense> expenses = [];
  bool isLoading = true;
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => isLoading = true);
    final data = await ExpenseDatabase.instance.getExpensesByMonth(
      selectedMonth.year,
      selectedMonth.month,
    );
    setState(() {
      expenses = data;
      isLoading = false;
    });
  }

  double get totalExpense {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  Map<String, double> get categoryTotals {
    Map<String, double> totals = {};
    for (var expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(),
        backgroundColor: primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Thêm chi tiêu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Quản Lý Chi Tiêu',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),

          // Month Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedMonth = DateTime(
                      selectedMonth.year,
                      selectedMonth.month - 1,
                    );
                  });
                  _loadExpenses();
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  'Tháng ${selectedMonth.month} - ${selectedMonth.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedMonth = DateTime(
                      selectedMonth.year,
                      selectedMonth.month + 1,
                    );
                  });
                  _loadExpenses();
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Total Amount
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Tổng chi tiêu',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${NumberFormat.currency(locale: 'vi', symbol: '₫').format(totalExpense)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có chi tiêu nào',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPieChart(),
          const SizedBox(height: 30),
          _buildExpensesList(),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    if (categoryTotals.isEmpty) return const SizedBox();

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống Kê theo danh mục',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: categoryTotals.entries.map((entry) {
                  final index = categoryTotals.keys.toList().indexOf(entry.key);
                  final percentage = (entry.value / totalExpense * 100);
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categoryTotals.entries.map((entry) {
              final index = categoryTotals.keys.toList().indexOf(entry.key);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors[index % colors.length].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colors[index % colors.length].withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Expense.getCategoryIcon(entry.key),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entry.key,
                      style: TextStyle(
                        color: colors[index % colors.length],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lịch sử chi tiêu',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return Dismissible(
              key: Key(expense.id.toString()),
              background: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                await ExpenseDatabase.instance.delete(expense.id!);
                _loadExpenses();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa chi tiêu')),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        Expense.getCategoryIcon(expense.category),
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                expense.category,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                ' • ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '-${NumberFormat.currency(locale: 'vi', symbol: '₫').format(expense.amount)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddExpenseDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = Expense.categories[0];
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thêm chi tiêu mới',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Số tiền',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: Expense.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Text(
                            Expense.getCategoryIcon(category),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(category),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() => selectedCategory = value!);
                  },
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setModalState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          amountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng điền đầy đủ thông tin'),
                          ),
                        );
                        return;
                      }

                      final expense = Expense(
                        title: titleController.text,
                        amount: double.parse(amountController.text),
                        category: selectedCategory,
                        date: selectedDate,
                      );

                      await ExpenseDatabase.instance.create(expense);
                      _loadExpenses();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Thêm chi tiêu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}