

import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double sliderValue = 50;
  bool switching = true;
  String? selectedGenre = 'Action';
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Excercise 2: Input Controller"),),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(
            'Rating Slider',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Slider(value: sliderValue,min: 0,max: 100, onChanged: (newValue){
            setState(() {
              sliderValue = newValue;
            });
          }),
          Text("Value $sliderValue"),
          Row(
            children: [
              Text("Is movie active"),
              Spacer(),
              Switch(value: switching, onChanged: (newValue){
                setState(() {
                  switching = newValue;
                });
              })
            ],
          ),
          RadioGroup<String>(
            groupValue: selectedGenre,
            onChanged: (newValue) {
              setState(() {
                selectedGenre = newValue;
              });
            },
            child: const Column(
              children: [
                RadioListTile<String>(
                  title: Text('Action'),
                  value: 'Action',
                ),
                RadioListTile<String>(
                  title: Text('Comedy'),
                  value: 'Comedy',
                ),
              ],
            ),
          ),
          Text("Selected Genre: $selectedGenre"),
          ElevatedButton(onPressed: () async {
            final date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if(date != null && mounted){
              setState(() {
                selectedDate = date;
              });
            }
          }, child: Text(
            selectedDate == null
                ? 'No date selected'
                : 'Selected date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
          ))
        ],
      )
    );
  }
}
