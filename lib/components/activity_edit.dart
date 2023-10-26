import 'package:curso_de_flutter/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityEdit extends StatefulWidget {
  final Activity existingActivity;
  final void Function(Activity) alterActivity;

  const ActivityEdit(this.existingActivity, this.alterActivity, {super.key});

  @override
  State<ActivityEdit> createState() => _ActivityEditState();
}

class _ActivityEditState extends State<ActivityEdit> {
  final TextEditingController _titleController = TextEditingController();
  bool _switchValue = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.existingActivity.title;
    _switchValue = widget.existingActivity.active;
    _selectedDate = widget.existingActivity.date;
  }

  _submitForm() {
    final title = _titleController.text;
    final active = _switchValue;
    final selectedDate = _selectedDate;

    if (title.isEmpty || selectedDate == null) {
      return;
    }

    widget.existingActivity.title = title;
    widget.existingActivity.active = active;
    widget.existingActivity.date = selectedDate;

    // Faça algo com os dados atualizados, como salvar no banco de dados

    widget.alterActivity(Activity(
      id: widget.existingActivity.id,
      title: title,
      active: active,
      date: selectedDate,
    ));

    Navigator.of(context).pop();
  }

  _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
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
                          ? 'Nenhuma data selecionada!'
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
                  style: ButtonStyle(),
                  onPressed: () => _submitForm(),
                  child: const Text('Alterar Atividade'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
