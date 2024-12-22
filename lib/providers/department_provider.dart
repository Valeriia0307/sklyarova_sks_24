import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyarova_sks_24_1/models/department.dart';

final departmentsProvider = Provider((ref) {
  return const [
    Department(
      id: 'd1',
      name: 'Finance',
      color: Colors.deepOrange,
      icon: Icons.money,
    ),
    Department(
      id: 'd2',
      name: 'Law',
      color: Colors.deepPurple,
      icon: Icons.local_police,
    ),
    Department(
      id: 'd3',
      name: 'IT',
      color: Color.fromARGB(255, 11, 146, 79),
      icon: Icons.devices,
    ),
    Department(
      id: 'd4',
      name: 'Medical',
      color: Color.fromARGB(255, 9, 73, 124),
      icon: Icons.bed,
    )
  ];
});
