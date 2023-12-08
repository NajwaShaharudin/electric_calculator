import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class electricalCalculator extends StatefulWidget {
  @override
  State<electricalCalculator> createState() => _electricalCalculatorState();
}

class _electricalCalculatorState extends State<electricalCalculator> {

  TextEditingController previousReadingController = TextEditingController();
  TextEditingController currentReadingController = TextEditingController();
  TextEditingController resultController = TextEditingController();
  String selectedRate = '0.095';
  double rate = 0.0;
  String totalAmount = '';
  String result = '';

  @override
  void initState(){
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      previousReadingController.text = prefs.getString('_prevMonth') ?? '';
      currentReadingController.text = prefs.getString('_currMonth') ?? '';
      selectedRate = prefs.getString('_selectedRate') ?? '0.095';
      totalAmount = prefs.getString('_totalAmount') ?? '';
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_prevMonth', previousReadingController.text);
    await prefs.setString('_currMonth', currentReadingController.text);
    await prefs.setString('selectedRate', selectedRate);
    await prefs.setString('_totalAmount', totalAmount);
  }

   void _calculateTotalPrice(){
    if (previousReadingController.text.isNotEmpty && currentReadingController.text.isNotEmpty){
      double previousReading = double.parse(previousReadingController.text);
      double currentReading = double.parse(currentReadingController.text);

      double totalKWhUsed = currentReading - previousReading;
      double totalPrice = totalKWhUsed * double.parse(selectedRate);

      setState(() {
       totalAmount = 'Total kWh used: $totalKWhUsed\nTotal Price: RM $totalPrice';
      });
    }else{
      setState(() {
        result = 'Please enter readings for current and previous month';
      });
    }
    _saveData(); //Save data after calculation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Electrical Usage Calculator', style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(

          children: <Widget> [
            Text('Previous Month Reading:'),
            TextField(
              controller: previousReadingController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text('Current Month Reading:'),
            TextField(
              controller: currentReadingController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text('Rate:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: <Widget>[
                Radio(
                    value: '0.095',
                    groupValue: selectedRate,
                    onChanged: (value){
                      setState(() {
                        selectedRate = value.toString();
                      });
                    },),
                Text('Residential'),
                Radio(
                    value: '0.125',
                    groupValue: selectedRate,
                    onChanged: (value){
                      setState(() {
                        selectedRate = value.toString();
                      });
                    },),
                Text('Industrial'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _calculateTotalPrice,
                child: Text('Calculate Charge and Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Total Amount: $totalAmount',
              style: TextStyle(fontSize: 18.0),
            )
          ],
        ),
      ),

    );
  }
}