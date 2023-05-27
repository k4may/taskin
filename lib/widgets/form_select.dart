import 'package:flutter/material.dart';

class FormSelect extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelect;
  final String labeltext;
  final int initialValue; // New parameter for initial selected index
  FormSelect({
    required this.items,
    required this.onSelect,
    required this.labeltext,
    this.initialValue = 0, // Default initial value is set to 0
  });

  @override
  _FormSelectState createState() => _FormSelectState();
}

class _FormSelectState extends State<FormSelect> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.items[widget.initialValue]; // Set initial selected item
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedItem = newValue;
            widget.onSelect(newValue);
          });
        }
      },
      decoration: InputDecoration(
        labelText: widget.labeltext,
        border: OutlineInputBorder(),
      ),
    );
  }
}
