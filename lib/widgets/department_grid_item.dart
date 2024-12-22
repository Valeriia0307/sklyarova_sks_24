import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyarova_sks_24_1/models/department.dart';
import 'package:sklyarova_sks_24_1/models/student.dart';

class DepartmentGridItem extends ConsumerWidget {
  const DepartmentGridItem(
      {super.key, required this.department, required this.students});

  final Department department;
  final List<Student> students;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = students
        .where((student) => student.departmentId == department.id)
        .length;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            department.color.withOpacity(0.55),
            department.color.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            department.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Text(
            'Students enrolled : $amount',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Row(
            children: [
              const Spacer(),
              Icon(department.icon),
            ],
          ),
        ],
      ),
    );
  }
}
