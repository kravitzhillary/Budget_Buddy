import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  final double savingsPerMonth;
  final double monthlyIncome;

  const OptionScreen({
    super.key,
    required this.savingsPerMonth,
    required this.monthlyIncome,
  });

  @override
  State<OptionScreen> createState() {
    return _OptionScreenState();
  }
}

class _OptionScreenState extends State<OptionScreen> {
  final _savingPerMonthText = TextEditingController();
  final _monthlyIncomeText = TextEditingController();

  /*
    This will use a form object, which contains easy-to-use
    validation properties.

    Here, if all data is good, pop to other screen via navigation with transaction data.
    {date: ..., amount: ...}
  */
  void _submitData() {
    Navigator.of(context).pop({
      "savingPerMonth": double.parse(_savingPerMonthText.text),
      "monthlyIncome": double.parse(_monthlyIncomeText.text),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Option Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Savings Per Month',
                ),
                controller: _savingPerMonthText,
                validator: (value) {
                  if (value == null) {
                    return 'ERROR: This field cannot be blank.';
                  }

                  return value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Monthly Income'),
                controller: _monthlyIncomeText,
                validator: (value) {
                  if (value == null) {
                    return 'ERROR: This field cannot be blank.';
                  }

                  return value;
                },
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
