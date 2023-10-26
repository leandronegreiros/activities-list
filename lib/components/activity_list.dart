import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import 'activity_edit.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final void Function(String) onRemove;
  final void Function(String) onAlter;
  final void Function(Activity) alterActivity;

  const ActivityList(this.activities, this.onRemove, this.onAlter, this.alterActivity,{super.key});

  @override
  Widget build(BuildContext context) {
    _alterActivity(BuildContext context, Activity updateActivity) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return ActivityEdit(updateActivity, alterActivity);
        },
      );
    }

    return activities.isEmpty
        ? Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                'Nenhuma Atividade Cadastrada!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
              )
            ],
          )
        : ListView.builder(
            itemCount: activities.length,
            itemBuilder: (BuildContext context, int index) {
              final tr = activities[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    'Termino: ${DateFormat('d MMM y').format(tr.date)} ${DateFormat('HH:mm').format(tr.date)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        onChanged: (bool? value) {
                          onAlter(tr.id);
                        },
                        value: tr.active,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _alterActivity(
                            context,
                            Activity(
                              id: tr.id,
                              title: tr.title,
                              active: tr.active,
                              date: tr.date,
                            )),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => onRemove(tr.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
