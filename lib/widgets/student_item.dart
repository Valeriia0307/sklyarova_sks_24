import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyarova_sks_24_1/models/department.dart';
import 'package:sklyarova_sks_24_1/models/student.dart';
import 'package:sklyarova_sks_24_1/providers/department_provider.dart';

class StudentsItem extends ConsumerWidget {
  const StudentsItem({
    super.key,
    required this.student,
    required this.onEditStudent,
  });

  final Student student;
  final void Function(Student student) onEditStudent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableDepartments = ref.watch(departmentsProvider);
    // Find the department for this student
    final department = availableDepartments.firstWhere(
      (department) => department.id == student.departmentId,
      orElse: () => const Department(
          id: '',
          name: 'Unknown',
          color: Colors.grey,
          icon: Icons.error), // Fallback if department is not found
    );
    return InkWell(
      onTap: () => onEditStudent(student),
      child: Card(
        color: genderColors[student.gender],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Text(
                "${student.firstName} ${student.lastName}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              const Spacer(),
              Icon(department.icon),
              const SizedBox(width: 10),
              Text(
                "${student.grade}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}