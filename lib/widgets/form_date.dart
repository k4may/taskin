import 'package:flutter/material.dart';
import 'package:taskin/widgets/space.dart';

class FormDate extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;

  FormDate({
    required this.dateController,
    required this.timeController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: dateController,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  dateController.text =
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                }
              });
            },
            decoration: const InputDecoration(
              labelText: 'Data',
              border: OutlineInputBorder()
            ),
          ),
        ),
        Spc(width: 8),
        Expanded(
          child: TextFormField(
            controller: timeController,
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((selectedTime) {
                if (selectedTime != null) {
                  timeController.text = selectedTime.format(context);
                }
              });
            },
            decoration: const InputDecoration(
              labelText: 'Hora',
              border:  OutlineInputBorder()
            ),
          ),
        ),
      ],
    );
  }
}
