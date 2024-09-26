import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(BuildContext)? onEditHabitPressed;
  final void Function(BuildContext)? onDeleteHabitPressed;
  final void Function(bool?)? onChanged;
  const HabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onEditHabitPressed,
    required this.onDeleteHabitPressed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      //     margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // edit option
            SlidableAction(
              onPressed: onEditHabitPressed,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              icon: Icons.settings,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            // delete option
            SlidableAction(
              onPressed: onDeleteHabitPressed,
              backgroundColor: Colors.red.shade600,
              icon: Icons.delete,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          // habit tile
          child: Container(
            height: 80,
            decoration: BoxDecoration(
                color: (isCompleted)
                    ? Colors.green
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: ListTile(
                title: Text(
                  text,
                  style: TextStyle(
                    color: (isCompleted)
                        ? Colors.white
                        : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                // checkbox
                leading: Checkbox(
                  activeColor: Colors.green,
                  value: isCompleted,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
