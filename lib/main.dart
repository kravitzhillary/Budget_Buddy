import 'package:budget_buddy/AddTransactionScreen.dart';
import 'package:budget_buddy/OptionScreen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Budget App';
    return MaterialApp(title: appTitle, home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return new _MainPageState();
  }
}

/*

    Hardcoded Data:
      - runningBalance: 5000.0 (double) | manually entered at start
      - monthlyIncome: 3000.0 (double) | manually entered
      - transactions: [
            {date: 10/3/2025, amount: -250.0},
            {date: 10/3/2025, amount: -1000.0}, 
            {date: 10/3/2025, amount: 500.0}
          ] (List<String>)
      - currentSavings: 1000.0 (double)
      - savingsPerMonth: 500.0 (double)
*/

class _MainPageState extends State<MainPage> {
  double _runningBalance = 4250.0; // (double) | manually entered at start
  double _monthlyIncome = 3000.0; // (double) | manually entered
  List<Map<String, dynamic>> _transactions = [
    {"date": "10/3/2025", "amount": -250.0, "balanceStamp": 4250.0},
    {"date": "10/3/2025", "amount": -1000.0, "balanceStamp": 4500.0},
    {"date": "10/3/2025", "amount": 500.0, "balanceStamp": 5500.0},
  ]; //  (List<String>)
  double _currentSavings = 1000.0; //  (double)
  double _savingsPerMonth = 500.0; // (double)

  int _currentIndex = 0;

  /*
    Add transaction will append to our list of transactions
    It will also decrement and incremenet our runningBalance
  */
  void _navigateToAddTransactionScreen() async {
    Map<String, dynamic>? response = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );

    if (response == null) {
      return;
    }

    try {
      final newTransaction = Map<String, dynamic>.from(response);
      final double amount = newTransaction["amount"];
      newTransaction["balanceStamp"] = (_runningBalance + amount);

      setState(() {
        _transactions.insert(0, newTransaction);
        _runningBalance +=
            newTransaction["amount"]; // if amount is negative, it will subtract, if positive, it will add
      });
    } catch (e) {
      throw Error();
    }
  }

  void _navigateToOptionScreen() async {
    Map<String, dynamic>? response = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OptionScreen(
          monthlyIncome: _monthlyIncome,
          savingsPerMonth: _savingsPerMonth,
        ),
      ),
    );

    if (response == null) {
      return;
    }

    try {
      setState(() {
        _monthlyIncome = response["monthlyIncome"];
        _savingsPerMonth = response["savingPerMonth"];
        _currentIndex = 0;
      });
    } catch (e) {
      throw Error();
    }
  }

  void _updateIndex(int index) {
    if (index == 1) {
      setState(() {
        _currentIndex = index;
      });

      _navigateToOptionScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Budget App';
    return new Scaffold(
      appBar: new AppBar(title: const Text(appTitle)),
      body: Center(
        child: new Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Current Balance',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        width: 20,
                      ), // This should display our current balance/savings
                      const Text(
                        'Monthly Income',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_runningBalance.toStringAsFixed(2)),
                      const SizedBox(
                        width: 20,
                      ), // This should display our current balance/savings
                      Text(_monthlyIncome.toStringAsFixed(2)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Transactions',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 50),
                        ElevatedButton(
                          onPressed: () {
                            _navigateToAddTransactionScreen();
                          },
                          child: const Text('Add Transaction'),
                        ),
                      ],
                    ),
                    _transactions.isEmpty
                        ? const Text('No Transactions')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _transactions[index];
                              return ListTile(
                                title: Text(transaction['date'].toString()),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      'Amount: ${transaction['amount'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: transaction['amount'] < 0
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Balance: ${transaction['balanceStamp'].toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    // This should display all of our transactions | Listview Builder
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ), // index 0
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Options',
          ), // index 1
        ],
        // Add onTap handler and currentIndex for interactivity
        currentIndex: _currentIndex,
        onTap: _updateIndex,
      ),
    );
  }
}

/*
  We render the MyApp element which surrounds
  MainPage with a MaterialApp widget
  This allows us to use Navigation FROM the MainPage.
*/
void main() => runApp(const MyApp());
