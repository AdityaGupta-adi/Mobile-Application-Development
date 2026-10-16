import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseTrackerScreen(),
    );
  }
}

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() =>
      _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  Database? database;

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  List<Map<String, dynamic>> expenses = [];
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q9_expenses.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL
          )
        ''');
      },
    );

    await loadExpenses();
  }

  Future<void> loadExpenses() async {
    if (database == null) return;

    final result = await database!.query(
      'expenses',
      orderBy: 'id DESC',
    );

    final totalResult = await database!.rawQuery(
      'SELECT SUM(amount) AS total FROM expenses',
    );

    final total =
        (totalResult.first['total'] as num?)?.toDouble() ?? 0.0;

    if (!mounted) return;

    setState(() {
      expenses = result;
      totalExpense = total;
    });
  }

  Future<void> addExpense() async {
    if (database == null) return;

    final title = titleController.text.trim();
    final amountText = amountController.text.trim();
    final amount = double.tryParse(amountText);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid title and amount greater than 0'),
        ),
      );
      return;
    }

    await database!.insert('expenses', {
      'title': title,
      'amount': amount,
    });

    titleController.clear();
    amountController.clear();

    await loadExpenses();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                size: 35,
              ),
              title: const Text('Total Expense'),
              subtitle: Text(
                '₹${totalExpense.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Expense Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: addExpense,
                    child: const Text('Add Expense'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Text(
            'Expense History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('No expenses added yet'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];

                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(expense['title']),
                        trailing: Text(
                          '₹${(expense['amount'] as num).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
