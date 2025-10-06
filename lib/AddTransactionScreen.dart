import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() {
    return _AddTransactionScreenState();
  }
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  /*
    This will use a form object, which contains easy-to-use
    validation properties.

    Here, if all data is good, pop to other screen via navigation with transaction data.
    {date: ..., amount: ...}
  */
  void _submitData() {
    Navigator.of(context).pop({
      "date": _dateController.text,
      "amount": double.parse(_amountController.text),
      "balanceStamp": 0.0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Enter Date'),
                controller: _dateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ERROR: This field cannot be blank.';
                  }

                  return value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter Amount (- or +)',
                ),
                controller: _amountController,
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
