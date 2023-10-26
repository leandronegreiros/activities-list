import 'package:curso_de_flutter/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityForm extends StatefulWidget {
  final Function(String, bool, DateTime) onSubmit;
  // final Activity? updateActivity;

  const ActivityForm(this.onSubmit, {super.key});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final TextEditingController _titleController = TextEditingController();

  bool _switchValue = false;
  DateTime? _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    var active = _switchValue;

    if (title.isEmpty || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, active, _selectedDate!);
  }

  _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:  DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(labelText: 'Título')),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhum data selecionada!'
                          : 'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedDate!)} ${DateFormat('HH:mm').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      'Selecionar a Data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _showDatePicker(),
                  )
                ],
              ),
            ),
            Row(
              children: [
                const Text('Ativo'),
                Switch(
                  onChanged: (bool? value) {
                    setState(() {
                      _switchValue = value!;
                    });
                  },
                  value: _switchValue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).bottomAppBarTheme.color),
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () => _submitForm(),
                  child: const Text('Nova Atividade'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
