import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyarova_sks_24_1/models/department.dart';
import 'package:sklyarova_sks_24_1/models/student.dart';
import 'package:sklyarova_sks_24_1/providers/department_provider.dart';

class NewStudent extends ConsumerStatefulWidget {
  const NewStudent({
    super.key,
    required this.onAddStudent,
    this.existingStudent,
  });

  final void Function(Student student) onAddStudent;
  final Student? existingStudent;
  
  static get ref => null;
  @override
  ConsumerState<NewStudent> createState() {
    return _NewStudentState();
  }
}

class _NewStudentState extends ConsumerState<NewStudent> {
  late final _firstnameController =
      TextEditingController(text: widget.existingStudent?.firstName ?? '');
  late final _lastnameController =
      TextEditingController(text: widget.existingStudent?.lastName ?? '');
  late final _gradeController = TextEditingController(
      text: widget.existingStudent != null
          ? widget.existingStudent!.grade.toString()
          : '');
  Department _selectedDepartment = const Department(
          id: 'd1', name: 'Finance', color: Colors.deepOrange, icon: Icons.money);

  late Gender _selectedGender = widget.existingStudent?.gender ?? Gender.female;

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _submitStudentData() {
    final enteredAmount = int.tryParse(_gradeController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    final firstnameIsInvalid = _firstnameController.text.trim().isEmpty;
    final lastnameIsInvalid = _lastnameController.text.trim().isEmpty;

    if (amountIsInvalid || firstnameIsInvalid || lastnameIsInvalid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input!'),
          content: const Text(
              'Make sure you`ve entered the valid values into those fields'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      return;
    }

    widget.onAddStudent(
      widget.existingStudent?.copyWith(
            firstName: _firstnameController.text,
            lastName: _lastnameController.text,
            departmentId: _selectedDepartment.id,
            grade: enteredAmount,
            gender: _selectedGender,
          ) ??
          Student(
              firebaseKey: '',
              firstName: _firstnameController.text,
              lastName: _lastnameController.text,
              departmentId: _selectedDepartment.id,
              grade: enteredAmount,
              gender: _selectedGender),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final availableDepartments = ref.watch(departmentsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 35, 25, 25),
      child: Column(
        children: [
          TextField(
            controller: _firstnameController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text('first name')),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          TextField(
            controller: _lastnameController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text('last name')),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          TextField(
            controller: _gradeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(label: Text('grade')),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                DropdownButton(
                    value: _selectedDepartment,
                    items: availableDepartments
                        .asMap() // Convert list to map with indexes
                        .map(
                          (index, department) {
                            return MapEntry(
                              index,
                              DropdownMenuItem<Department>(
                                value: department,
                                child: Row(
                                  children: [
                                    Icon(department.icon),
                                    const SizedBox(width: 8), 
                                    Text(department.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        .values
                        .toList(),
                    onChanged: (Department? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedDepartment =
                              newValue; // Update the selected department and rebuild
                        });
                      }
                    }),
                const Spacer(),
                DropdownButton(
                    value: _selectedGender,
                    items: Gender.values
                        .map(
                          (gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(
                              gender.name.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedGender = value;
                      });
                    })
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
              ),
              const SizedBox(
                width: 150,
              ),
              ElevatedButton(
                onPressed: _submitStudentData,
                child: const Text('Save Student'),
              ),
            ],
          )
        ],
      ),
    );
  }
}