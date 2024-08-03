import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todoName,
    required this.taskDone,
    required this.onChanged,
    required this.onDelete,
  });

  final String todoName;
  final bool taskDone;
  final void Function(bool) onChanged;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Slidable(
        key: Key(todoName),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: const Color.fromARGB(255, 140, 23, 23),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 71, 71, 71),
          ),
          child: Row(
            children: [
              MSHCheckbox(
                size: 20,
                value: taskDone,
                colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                    checkedColor: Color.fromARGB(255, 29, 29, 29),
                    uncheckedColor: Color.fromARGB(255, 152, 151, 151)),
                style: MSHCheckboxStyle.fillFade,
                onChanged: onChanged,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  todoName,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 214, 212, 212),
                    decoration: taskDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
