import 'package:flutter/material.dart';

class Department {
  const Department({required this.id, required this.name, required this.color, required this.icon});
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  
  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    return other is Department && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
