import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Unit Converter',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = 'Kilometers';
  String _toUnit = 'Miles';
  String _result = '';

  final List<String> allUnits = [
    'Kilometers',
    'Miles',
    'Meters',
    'Yards',
    'Centimeters',
    'Inches',
    'Kilograms',
    'Pounds',
    'Grams',
    'Ounces',
    'Celsius',
    'Fahrenheit',
  ];

  final Map<String, double> conversionRates = {
    // Length
    'Kilometers_Miles': 0.621371,
    'Miles_Kilometers': 1.60934,
    'Meters_Yards': 1.09361,
    'Yards_Meters': 0.9144,
    'Centimeters_Inches': 0.393701,
    'Inches_Centimeters': 2.54,

    // Weight
    'Kilograms_Pounds': 2.20462,
    'Pounds_Kilograms': 0.453592,
    'Grams_Ounces': 0.035274,
    'Ounces_Grams': 28.3495,
  };

  void _convert() {
    double? input = double.tryParse(_inputController.text);
    if (input == null) {
      setState(() => _result = 'Invalid input');
      return;
    }

    if (_fromUnit == _toUnit) {
      setState(() => _result = input.toStringAsFixed(2));
      return;
    }

    double? convertedValue;
    String key = '${_fromUnit}_$_toUnit';

    // Handle temperature separately
    if ((_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit')) {
      convertedValue = (input * 9 / 5) + 32;
    } else if ((_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius')) {
      convertedValue = (input - 32) * 5 / 9;
    } else {
      // Look up conversion rate
      double? rate = conversionRates[key];
      if (rate != null) {
        convertedValue = input * rate;
      } else {
        setState(() => _result = 'Conversion not supported');
        return;
      }
    }

    setState(() {
      _result = convertedValue!.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simple Unit Converter',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Input field
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // From unit dropdown
            DropdownButtonFormField<String>(
              value: _fromUnit,
              decoration: InputDecoration(
                labelText: 'From',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _fromUnit = value!);
              },
              items: allUnits.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
            ),
            SizedBox(height: 20),

            // To unit dropdown
            DropdownButtonFormField<String>(
              value: _toUnit,
              decoration: InputDecoration(
                labelText: 'To',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _toUnit = value!);
              },
              items: allUnits.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
            ),
            SizedBox(height: 30),

            // Convert button
            ElevatedButton(onPressed: _convert, child: Text('Convert')),
            SizedBox(height: 30),

            // Result
            Text('Result: $_result', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
