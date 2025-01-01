import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twine/helper.dart';

class TextDateField extends StatefulWidget {
  const TextDateField({
    super.key,
    required this.initDate,
    required this.setDate,
    this.firstDate,
    this.lastDate,
  });

  final DateTime initDate;
  final void Function(DateTime) setDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  @override
  State<TextDateField> createState() => _TextDateFieldState();
}

class _TextDateFieldState extends State<TextDateField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = DateFormat('d MMM yyyy').format(widget.initDate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectDate(DateTime selectedDate) {
    widget.setDate(selectedDate);
    _controller.text = DateFormat('d MMM yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => showDatePickerDialog(context, widget.initDate, _selectDate,
            firstDate: widget.firstDate, lastDate: widget.lastDate),
            
        child: AbsorbPointer(
            child: TextField(
          controller: _controller,
          readOnly: true,
          textAlign: TextAlign.center,
        )));
  }
}
