import 'package:flutter/material.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BMI Calculator',
        theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const HomeScreen(),
        );
    }
}

class HomeScreen extends StatefulWidget {
    const HomeScreen({Key? key}) : super(key: key);

@override
_HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    bool showHistory = false;
    List<BmiRecord> bmiRecords = [];

void addBmiRecord(BmiRecord record) {
    setState(() {
        bmiRecords.add(record);
    });
    }

@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("BMI Calculator")),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    _buildNavButton("Calculate BMI", false),
                    const SizedBox(width: 10),
                    _buildNavButton("View History", true),
                ],
                ),
                const SizedBox(height: 20),
                Expanded(
                child: showHistory
                    ? BmiHistory(records: bmiRecords)
                    : BmiCalculator(onCalculate: addBmiRecord),
                ),
            ],
            ),
        ),
    );
}

Widget _buildNavButton(String label, bool history) {
    return ElevatedButton(
        onPressed: () => setState(() => showHistory = history),
        child: Text(label),
        );
    }
}

class BmiCalculator extends StatefulWidget {
    final Function(BmiRecord) onCalculate;
    const BmiCalculator({Key? key, required this.onCalculate}) : super(key: key);

@override
_BmiCalculatorState createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
    final _nameController = TextEditingController();
    final _heightController = TextEditingController();
    final _weightController = TextEditingController();

void _calculateBMI() {
    final name = _nameController.text;
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (name.isEmpty || height == null || weight == null || height <= 0) {
    return;
    }

    final bmi = weight / ((height / 100) * (height / 100));
    String category = (bmi < 18.5)
        ? "Underweight"
        : (bmi < 24.9)
            ? "Normal"
            : (bmi < 29.9)
                ? "Overweight"
                : "Obese";

    widget.onCalculate(BmiRecord(name: name, bmi: bmi, category: category));

    setState(() {
        _nameController.clear();
        _heightController.clear();
        _weightController.clear();
        });
    }

@override
Widget build(BuildContext context) {
    return Column(
        children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _heightController, decoration: const InputDecoration(labelText: "Height (cm)"), keyboardType: TextInputType.number),
            TextField(controller: _weightController, decoration: const InputDecoration(labelText: "Weight (kg)"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _calculateBMI, child: const Text("Calculate BMI")),
            ],
        );
    }
}

class BmiHistory extends StatelessWidget {
    final List<BmiRecord> records;
    const BmiHistory({Key? key, required this.records}) : super(key: key);

@override
Widget build(BuildContext context) {
    return records.isEmpty
        ? const Center(child: Text("No records yet."))
        : ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
                final record = records[index];
                return ListTile(
                title: Text("${record.name}: ${record.bmi.toStringAsFixed(1)}"),
                subtitle: Text("Category: ${record.category}"),
                );
            },
        );
    }
}

class BmiRecord {
    final String name;
    final double bmi;
    final String category;

    BmiRecord({required this.name, required this.bmi, required this.category});
}